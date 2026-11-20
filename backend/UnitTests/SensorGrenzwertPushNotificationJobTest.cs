using API.Clients.BereichBClient;
using API.Features.PushNotifications;
using API.Features.PushNotifications.Jobs;
using API.Infrastructure;
using Microsoft.Extensions.Logging.Abstractions;
using Moq;
using StrawberryShake;

namespace IntegrationTests;

public class SensorGrenzwertPushNotificationJobTest {
    [Fact]
    public async Task SendsPushAndPersistsWatermark_WhenPendingCandidateConfirmed() {
        var firebase = new RecordingFirebasePushMessagingService();
        var logger = new RecordingLogger<SensorGrenzwertPushNotificationJob>();
        var client = new Mock<IBereichBClient>();
        var sensorenQuery = new Mock<ISensorenGefahrenstufenQuery>();
        var setNotifiedMutation = new Mock<ISetSensorGefahrenstufeNotifiedMutation>();

        client.Setup(c => c.SensorenGefahrenstufen).Returns(sensorenQuery.Object);
        client.Setup(c => c.SetSensorGefahrenstufeNotified).Returns(setNotifiedMutation.Object);

        sensorenQuery
            .Setup(q => q.ExecuteAsync(default))
            .ReturnsAsync(SensorenResult([
                new Doc("sensor-1", "R5_Remte Afferde", "Pegelsensor Afferde", "ROT", null, "GELB", "ROT"),
            ]));

        setNotifiedMutation
            .Setup(m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Rot, true, default))
            .ReturnsAsync(SetNotifiedResult());

        var job = new SensorGrenzwertPushNotificationJob(client.Object, logger, firebase);

        await job.Execute(JobExecutionContextTestHelper.Create(nameof(SensorGrenzwertPushNotificationJob)));

        var message = Assert.Single(firebase.Messages);
        Assert.Equal(new PushTopic.Sensor("sensor-1").ToString(), message.Topic);
        Assert.Equal("Pegelsensor Afferde", message.Notification.Title);
        Assert.Equal(
            "Die Informationsstufe hat sich von Stufe 2 auf Stufe 4 geändert.", message.Notification.Body);
        setNotifiedMutation.Verify(
            m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Rot, true, default), Times.Once);
        Assert.Contains(
            logger.Messages,
            m => m.Contains("sensor-1") && m.Contains("Stufe 2") && m.Contains("Stufe 4"));
    }

    [Fact]
    public async Task DoesNotSendPush_WhenGefahrenstufeUnchanged() {
        var firebase = new RecordingFirebasePushMessagingService();
        var client = new Mock<IBereichBClient>();
        var sensorenQuery = new Mock<ISensorenGefahrenstufenQuery>();

        client.Setup(c => c.SensorenGefahrenstufen).Returns(sensorenQuery.Object);
        sensorenQuery
            .Setup(q => q.ExecuteAsync(default))
            .ReturnsAsync(SensorenResult([
                new Doc("sensor-1", "R5_Remte Afferde", "Pegelsensor Afferde", "GRUEN", null, "GRUEN", "GRUEN"),
            ]));

        var job = new SensorGrenzwertPushNotificationJob(
            client.Object, NullLogger<SensorGrenzwertPushNotificationJob>.Instance, firebase);

        await job.Execute(JobExecutionContextTestHelper.Create(nameof(SensorGrenzwertPushNotificationJob)));

        Assert.Empty(firebase.Messages);
        client.Verify(c => c.SetSensorGefahrenstufeNotified, Times.Never);
    }

    [Fact]
    public async Task DoesNotSendPush_ButRecordsPendingCandidate_OnFirstOccurrence() {
        var firebase = new RecordingFirebasePushMessagingService();
        var client = new Mock<IBereichBClient>();
        var sensorenQuery = new Mock<ISensorenGefahrenstufenQuery>();
        var setNotifiedMutation = new Mock<ISetSensorGefahrenstufeNotifiedMutation>();

        client.Setup(c => c.SensorenGefahrenstufen).Returns(sensorenQuery.Object);
        client.Setup(c => c.SetSensorGefahrenstufeNotified).Returns(setNotifiedMutation.Object);

        // Grenzwert erstmals überschritten (z.B. eine einzelne Welle) - noch kein zweiter Lauf
        // mit demselben Wert, also noch kein bestätigter Kandidat.
        sensorenQuery
            .Setup(q => q.ExecuteAsync(default))
            .ReturnsAsync(SensorenResult([
                new Doc("sensor-1", "R5_Remte Afferde", "Pegelsensor Afferde", "ROT", null, "GELB", null),
            ]));

        setNotifiedMutation
            .Setup(m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Rot, false, default))
            .ReturnsAsync(SetNotifiedResult());

        var job = new SensorGrenzwertPushNotificationJob(
            client.Object, NullLogger<SensorGrenzwertPushNotificationJob>.Instance, firebase);

        await job.Execute(JobExecutionContextTestHelper.Create(nameof(SensorGrenzwertPushNotificationJob)));

        Assert.Empty(firebase.Messages);
        setNotifiedMutation.Verify(
            m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Rot, false, default), Times.Once);
    }

    [Fact]
    public async Task DiscardsStalePendingCandidate_WhenValueReturnsToNotifiedLevel() {
        var firebase = new RecordingFirebasePushMessagingService();
        var client = new Mock<IBereichBClient>();
        var sensorenQuery = new Mock<ISensorenGefahrenstufenQuery>();
        var setNotifiedMutation = new Mock<ISetSensorGefahrenstufeNotifiedMutation>();

        client.Setup(c => c.SensorenGefahrenstufen).Returns(sensorenQuery.Object);
        client.Setup(c => c.SetSensorGefahrenstufeNotified).Returns(setNotifiedMutation.Object);

        // Eine kurze Welle hatte "ROT" als Kandidaten hinterlassen, ist aber wieder abgeklungen:
        // der aktuelle Wert entspricht wieder der zuletzt gemeldeten Stufe "GELB".
        sensorenQuery
            .Setup(q => q.ExecuteAsync(default))
            .ReturnsAsync(SensorenResult([
                new Doc("sensor-1", "R5_Remte Afferde", "Pegelsensor Afferde", "GELB", null, "GELB", "ROT"),
            ]));

        setNotifiedMutation
            .Setup(m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Gelb, false, default))
            .ReturnsAsync(SetNotifiedResult());

        var job = new SensorGrenzwertPushNotificationJob(
            client.Object, NullLogger<SensorGrenzwertPushNotificationJob>.Instance, firebase);

        await job.Execute(JobExecutionContextTestHelper.Create(nameof(SensorGrenzwertPushNotificationJob)));

        Assert.Empty(firebase.Messages);
        setNotifiedMutation.Verify(
            m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Gelb, false, default), Times.Once);
    }

    [Fact]
    public async Task DoesNotSendPush_ButPersistsWatermark_OnFirstEverObservationConfirmed() {
        var firebase = new RecordingFirebasePushMessagingService();
        var client = new Mock<IBereichBClient>();
        var sensorenQuery = new Mock<ISensorenGefahrenstufenQuery>();
        var setNotifiedMutation = new Mock<ISetSensorGefahrenstufeNotifiedMutation>();

        client.Setup(c => c.SensorenGefahrenstufen).Returns(sensorenQuery.Object);
        client.Setup(c => c.SetSensorGefahrenstufeNotified).Returns(setNotifiedMutation.Object);

        // Sensor noch nie zuvor beobachtet (kein Watermark), Kandidat aus dem vorherigen Lauf
        // stimmt aber schon mit dem aktuellen Wert überein -> Baseline wird jetzt bestätigt.
        sensorenQuery
            .Setup(q => q.ExecuteAsync(default))
            .ReturnsAsync(SensorenResult([
                new Doc("sensor-1", "R5_Remte Afferde", "Pegelsensor Afferde", "GRUEN", null, null, "GRUEN"),
            ]));

        setNotifiedMutation
            .Setup(m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Gruen, true, default))
            .ReturnsAsync(SetNotifiedResult());

        var job = new SensorGrenzwertPushNotificationJob(
            client.Object, NullLogger<SensorGrenzwertPushNotificationJob>.Instance, firebase);

        await job.Execute(JobExecutionContextTestHelper.Create(nameof(SensorGrenzwertPushNotificationJob)));

        Assert.Empty(firebase.Messages);
        setNotifiedMutation.Verify(
            m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Gruen, true, default), Times.Once);
    }

    [Fact]
    public async Task RecordsFailure_WhenSetSensorGefahrenstufeNotifiedReportsFailure() {
        var firebase = new RecordingFirebasePushMessagingService();
        var client = new Mock<IBereichBClient>();
        var sensorenQuery = new Mock<ISensorenGefahrenstufenQuery>();
        var setNotifiedMutation = new Mock<ISetSensorGefahrenstufeNotifiedMutation>();

        client.Setup(c => c.SensorenGefahrenstufen).Returns(sensorenQuery.Object);
        client.Setup(c => c.SetSensorGefahrenstufeNotified).Returns(setNotifiedMutation.Object);

        sensorenQuery
            .Setup(q => q.ExecuteAsync(default))
            .ReturnsAsync(SensorenResult([
                new Doc("sensor-1", "R5_Remte Afferde", "Pegelsensor Afferde", "ROT", null, "GELB", "ROT"),
            ]));

        setNotifiedMutation
            .Setup(m => m.ExecuteAsync("sensor-1", SensorGefahrenstufe.Rot, true, default))
            .ReturnsAsync(SetNotifiedResult(success: false));

        var context = JobExecutionContextTestHelper.Create(nameof(SensorGrenzwertPushNotificationJob));
        var job = new SensorGrenzwertPushNotificationJob(
            client.Object, NullLogger<SensorGrenzwertPushNotificationJob>.Instance, firebase);

        await job.Execute(context);

        Assert.Single(firebase.Messages);
        Assert.Equal(1, context.GetItemFailureCount());
    }

    [Fact]
    public async Task DoesNotSendPush_WhenNoGefahrenstufeAvailable() {
        var firebase = new RecordingFirebasePushMessagingService();
        var client = new Mock<IBereichBClient>();
        var sensorenQuery = new Mock<ISensorenGefahrenstufenQuery>();

        client.Setup(c => c.SensorenGefahrenstufen).Returns(sensorenQuery.Object);
        sensorenQuery
            .Setup(q => q.ExecuteAsync(default))
            .ReturnsAsync(SensorenResult([
                new Doc("sensor-2", "unkonfigurierter_sensor", "Ohne Grenzwerte", null, null, null, null),
            ]));

        var job = new SensorGrenzwertPushNotificationJob(
            client.Object, NullLogger<SensorGrenzwertPushNotificationJob>.Instance, firebase);

        await job.Execute(JobExecutionContextTestHelper.Create(nameof(SensorGrenzwertPushNotificationJob)));

        Assert.Empty(firebase.Messages);
    }

    private static IOperationResult<ISensorenGefahrenstufenResult> SensorenResult(
        IReadOnlyList<ISensorenGefahrenstufen_Sensorens_Docs?> docs) {
        var data = new Result(new SensorenList(docs));
        return new OperationResult<ISensorenGefahrenstufenResult>(
            data, dataInfo: null!, dataFactory: null!, errors: [], extensions: null!, contextData: null!);
    }

    private static IOperationResult<ISetSensorGefahrenstufeNotifiedResult> SetNotifiedResult(bool success = true) {
        var data = new SetNotifiedPayloadResult(new NotifiedPayload(success));
        return new OperationResult<ISetSensorGefahrenstufeNotifiedResult>(
            data, dataInfo: null!, dataFactory: null!, errors: [], extensions: null!, contextData: null!);
    }

    private sealed record Doc(
        string? Id,
        string Name,
        string? Titel,
        string? PegelGefahrenstufe,
        string? GlaetteAlarmLevel,
        string? LetzteBenachrichtigteGefahrenstufe,
        string? AusstehendeGefahrenstufe) : ISensorenGefahrenstufen_Sensorens_Docs;

    private sealed record SensorenList(
        IReadOnlyList<ISensorenGefahrenstufen_Sensorens_Docs?>? Docs) : ISensorenGefahrenstufen_Sensorens;

    private sealed record Result(ISensorenGefahrenstufen_Sensorens? Sensorens) : ISensorenGefahrenstufenResult;

    private sealed record SetNotifiedPayloadResult(
        ISetSensorGefahrenstufeNotified_SetSensorGefahrenstufeNotified? SetSensorGefahrenstufeNotified)
        : ISetSensorGefahrenstufeNotifiedResult;

    private sealed record NotifiedPayload(bool? Success) : ISetSensorGefahrenstufeNotified_SetSensorGefahrenstufeNotified;
}
