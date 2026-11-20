part of 'antrag_progress.dart';

/// Notifier for managing the application progress and associated actions.
class AntragProgressNotifier extends _AntragProgressController
    with
        _AntragProgressNavigation,
        _AntragProgressPersistence,
        _AntragProgressSerialization,
        _AntragProgressSubmission,
        _AntragProgressExecution {
  @override
  AntragProgress? build() {
    return null;
  }

  /// Starts a new process with municipality, process and process version.
  void startProzess({
    required Kommune kommune,
    required Prozess prozess,
    required Fragment_ProzessVersion prozessVersion,
    EditableSlots? initialSlots,
  }) {
    _ausfuehrungKey = null;
    ref.read(searchCategorySelectionProvider.notifier).clear();
    state = AntragProgress(
      kommune: kommune,
      prozess: prozess,
      prozessVersion: prozessVersion,
      slots: initialSlots ?? const <String, dynamic>{},
      schritte: prozessVersion.ersteSchritte
          .whereNot((s) => s is Fragment_Schritt__BezahlenSchritt)
          .toList(),
    );
  }

  /// Starts a special process based on a tag and navigates to the route.
  Future<void> launchSpecialProzess({
    required String tag,
    required String route,
    required AntragMeta meta,
    required BuildContext context,
  }) async {
    if (state != null) {
      endProzess();
    }

    antrag_schritt.clearSchrittCacheForRoute(route);

    final client = ref.read(graphqlClientProvider);
    final kommuneId = ref.read(appConfigProvider).kommuneId;

    final data = await client.query_SpecialProzess(
      Options_Query_SpecialProzess(
        fetchPolicy: FetchPolicy.networkOnly,
        variables: Variables_Query_SpecialProzess(
          kommuneId: kommuneId,
          tag: tag,
        ),
      ),
    );

    final prozess = data.parsedData?.kommune.prozessByTag;
    final currentVersion = prozess?.currentVersion;

    if (prozess == null || currentVersion == null) return;

    startProzess(
      kommune: prozess.kommune,
      prozess: prozess,
      prozessVersion: currentVersion,
    );

    ref.read(antragMetaProvider.notifier).setMeta(meta);

    if (context.mounted) {
      context.go(route);
    }
  }

  /// Continues an existing execution based on ID.
  @override
  Future<AntragProgress?> continueAusfuehrung({
    required String id,
    bool keepAusfuehrungKey = false,
  }) async {
    if (!keepAusfuehrungKey) _ausfuehrungKey = null;
    ref.read(searchCategorySelectionProvider.notifier).clear();
    final client = ref.read(graphqlClientProvider);

    final ausfuehrung = await client.query_AusfuehrungFortsetzung(
      Options_Query_AusfuehrungFortsetzung(
        fetchPolicy: FetchPolicy.networkOnly,
        variables: Variables_Query_AusfuehrungFortsetzung(id: id),
      ),
    );

    if (ausfuehrung.hasException || ausfuehrung.parsedData == null) {
      return state;
    }

    final schritt = ausfuehrung.parsedData!.ausfuehrung.currentSchritt;
    final clientStatus = switch (schritt) {
      Fragment_Schritt__BezahlenSchritt() => AntragClientStatus.paying,
      Fragment_Schritt__WarteAufBezahlungAbgeschlossenSchritt() =>
        AntragClientStatus.paying,
      Fragment_Schritt__FormularSchritt(:final erledigungDurchBuerger)
          when !erledigungDurchBuerger =>
        AntragClientStatus.submitted,
      _ => AntragClientStatus.editing,
    };

    state = AntragProgress(
      sharedKeyEncryptedForBuerger:
          ausfuehrung.parsedData!.ausfuehrung.sharedKeyEncryptedForBuerger,
      prozess: ausfuehrung.parsedData!.ausfuehrung.prozessVersion.prozess,
      prozessVersion: ausfuehrung.parsedData!.ausfuehrung.prozessVersion,
      kommune:
          ausfuehrung.parsedData!.ausfuehrung.prozessVersion.prozess.kommune,
      schritte: [schritt],
      clientStatus: clientStatus,
      ausfuehrungId: id,
      slots: state?.slots ?? const <String, dynamic>{},
      slotErrors: state?.slotErrors ?? const <String, dynamic>{},
    );

    return state;
  }
}
