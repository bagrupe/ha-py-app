using API.Clients.BereichBClient;
using API.Features.PushNotifications;
using API.Infrastructure;
using FirebaseAdmin.Messaging;
using Quartz;
using StrawberryShake;

namespace API.Features.PushNotifications.Jobs;

/// <summary>
/// Job zum Versenden von Push-Benachrichtigungen bei Wechsel der Gefahrenstufe eines Sensors
/// (Pegelstand oder Glätte). Sendet an das entitätsspezifische Sensor-Topic, unabhängig davon,
/// ob/wie viele Nutzer den Sensor tatsächlich favorisiert haben.
/// </summary>
public class SensorGrenzwertPushNotificationJob(
    IBereichBClient bereichBClient,
    ILogger<SensorGrenzwertPushNotificationJob> logger,
    IFirebasePushMessagingService firebasePush
) : IJob {
    // Bewusst neutrale Stufennummer statt Farbe/Bewertungswort (Grün/Gelb/.../Gefahr/Warnung)
    // im Push-Text, auf fachlichen Wunsch: Nutzer sollen "Stufe X" lesen, nicht "Gefahr"/
    // "Entwarnung". Farben bleiben nur visuell (Tacho, Hinweisbox in der App) erhalten.
    private static readonly Dictionary<string, int> InformationsstufenIndex = new() {
        ["GRUEN"] = 1,
        ["SAFE"] = 1,
        ["GELB"] = 2,
        ["ADVISORY"] = 2,
        ["ORANGE"] = 3,
        ["WARNING"] = 3,
        ["ROT"] = 4,
        ["CRITICAL"] = 4,
    };

    /// <summary>Führt den Job aus und sendet Push-Benachrichtigungen für Sensoren mit geänderter Gefahrenstufe.</summary>
    /// <param name="context">Kontext des ausgeführten Jobs.</param>
    public async Task Execute(IJobExecutionContext context) {
        using var failures = context.TrackItemFailures();
        logger.LogInformation("Running");

        var result = await bereichBClient.SensorenGefahrenstufen.ExecuteAsync();

        foreach (var sensor in result.Data?.Sensorens?.Docs ?? []) {
            if (sensor is not { Id: { } sensorId, Name: { } name }) continue;

            var aktuelleGefahrenstufe = sensor.PegelGefahrenstufe ?? sensor.GlaetteAlarmLevel;
            if (aktuelleGefahrenstufe is null) continue;

            if (aktuelleGefahrenstufe == sensor.LetzteBenachrichtigteGefahrenstufe) {
                // Zustand entspricht wieder der zuletzt gemeldeten Stufe (z.B. eine kurze Welle
                // ist abgeklungen, bevor die Kandidatenstufe bestätigt wurde). Eine noch offene,
                // jetzt hinfällige Kandidatenstufe muss verworfen werden - sonst würde ein
                // späterer, unabhängiger Ausreißer auf denselben veralteten Kandidaten treffen
                // und fälschlich sofort (ohne erneute Bestätigung) als Push versendet.
                if (sensor.AusstehendeGefahrenstufe != aktuelleGefahrenstufe) {
                    await TryPersistAsync(
                        failures, sensorId,
                        () => bereichBClient.SetSensorGefahrenstufeNotified.ExecuteAsync(
                            sensorId, Enum.Parse<SensorGefahrenstufe>(aktuelleGefahrenstufe, ignoreCase: true),
                            confirmed: false),
                        "Failed to reset stale pending gefahrenstufe for {SensorId}");
                }
                continue;
            }

            // Debounce gegen kurze Ausreißer (z.B. eine einzelne Welle, die den Grenzwert für
            // einen Job-Lauf überschreitet): eine neue Stufe wird erst als Push versendet, wenn
            // sie auf zwei aufeinanderfolgenden Läufen denselben Wert zeigt, nicht sofort beim
            // ersten Auftreten.
            if (sensor.AusstehendeGefahrenstufe != aktuelleGefahrenstufe) {
                await TryPersistAsync(
                    failures, sensorId,
                    () => bereichBClient.SetSensorGefahrenstufeNotified.ExecuteAsync(
                        sensorId, Enum.Parse<SensorGefahrenstufe>(aktuelleGefahrenstufe, ignoreCase: true),
                        confirmed: false),
                    "Failed to persist pending gefahrenstufe for {SensorId}");
                continue;
            }

            // Watermark war noch nie gesetzt (erster Lauf nach Deploy bzw. Sensor neu in
            // gold_all_in_one aufgetaucht): Baseline nur persistieren, keine Push für einen
            // Zustand senden, den wir noch nie zuvor beobachtet haben (kein echter Wechsel).
            var istErstbeobachtung = sensor.LetzteBenachrichtigteGefahrenstufe is null;

            try {
                if (!istErstbeobachtung) {
                    var titel = sensor.Titel ?? name;
                    var alteStufe = InformationsstufenIndex.GetValueOrDefault(sensor.LetzteBenachrichtigteGefahrenstufe!);
                    var neueStufe = InformationsstufenIndex.GetValueOrDefault(aktuelleGefahrenstufe);

                    await firebasePush.SendAsync(new Message {
                        Android = new AndroidConfig { Priority = Priority.High },
                        Topic = new PushTopic.Sensor(sensorId).ToString(),
                        Data = new Dictionary<string, string> { { "type", "sensor" }, { "id", sensorId } },
                        Notification = new Notification {
                            Title = titel,
                            Body = $"Die Informationsstufe hat sich von Stufe {alteStufe} auf Stufe {neueStufe} geändert.",
                        },
                    });

                    logger.LogInformation(
                        "Sent sensor push notification for {SensorId} ({Titel}): Stufe {AlteStufe} -> Stufe {NeueStufe}",
                        sensorId, titel, alteStufe, neueStufe);
                }

                var notifiedResult = await bereichBClient.SetSensorGefahrenstufeNotified.ExecuteAsync(
                    sensorId, Enum.Parse<SensorGefahrenstufe>(aktuelleGefahrenstufe, ignoreCase: true),
                    confirmed: true);
                if (notifiedResult.Data?.SetSensorGefahrenstufeNotified?.Success != true) {
                    failures.RecordFailure();
                    logger.LogError(
                        "SetSensorGefahrenstufeNotified reported failure for {SensorId}, will retry next run",
                        sensorId);
                }
            } catch (Exception e) {
                failures.RecordFailure();
                logger.LogError(e, "Failed to send/persist sensor push for {SensorId}, will retry next run", sensorId);
            }
        }
    }

    private async Task TryPersistAsync(
        CronJobItemFailures failures, string sensorId,
        Func<Task<IOperationResult<ISetSensorGefahrenstufeNotifiedResult>>> persist, string errorMessageTemplate) {
        try {
            var pendingResult = await persist();
            if (pendingResult.Data?.SetSensorGefahrenstufeNotified?.Success != true) {
                failures.RecordFailure();
                logger.LogError(errorMessageTemplate, sensorId);
            }
        } catch (Exception e) {
            failures.RecordFailure();
            logger.LogError(e, errorMessageTemplate, sensorId);
        }
    }
}

/// <summary>
/// Erweiterungsmethoden zur Registrierung des Sensor-Grenzwert-Push-Notification-Jobs im DI-Container.
/// </summary>
public static class SensorGrenzwertPushNotificationJobExtensions {
    /// <summary>
    /// Registriert den Sensor-Grenzwert-Push-Notification-Job mit einem Intervall von 15 Minuten und sofortigem Start.
    /// </summary>
    /// <param name="services">Die Service-Sammlung zur Registrierung.</param>
    /// <returns>Die erweiterte Service-Sammlung.</returns>
    public static IServiceCollection AddSensorGrenzwertPushNotificationJob(this IServiceCollection services) {
        const string everyFifteenMinutes = "0 0/15 * ? * * *";

        services
            .AddOptions<QuartzOptions>()
            .Configure(quartz =>
                quartz.ScheduleJob<SensorGrenzwertPushNotificationJob>(everyFifteenMinutes, fireImmediate: true));

        return services;
    }
}
