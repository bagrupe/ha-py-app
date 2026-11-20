part of 'antrag_progress.dart';

/// Handles execution for the application controller.
mixin _AntragProgressExecution on _AntragProgressController {
  /// Loads the execution key using the account private key.
  Uint8List? _keyFromAccount() {
    final buergerPrivatKey = ref.read(authProvider).privateKey;
    if (buergerPrivatKey == null) {
      state = _state.copyWith(
        clientStatus: AntragClientStatus.errorKeyUnavailable,
      );
      return null;
    }
    return _unwrapAusfuehrungKey(
      _state.sharedKeyEncryptedForBuerger!,
      buergerPrivatKey,
    );
  }

  /// Unwraps the execution key and reports a key mismatch.
  Uint8List? _unwrapAusfuehrungKey(String wrappedKey, PrivateKey privateKey) {
    try {
      return Crypto.unwrapKey(wrappedKey, privateKey);
    } on Object {
      state = _state.copyWith(
        clientStatus: AntragClientStatus.errorKeyMismatch,
      );
      return null;
    }
  }

  /// Continues an execution.
  @override
  Future<void> ausfuehrungContinue() async {
    final encryptionKey = _ausfuehrungKey ?? _keyFromAccount();
    if (encryptionKey == null) return;

    final client = withAntragRequestTimeout(ref.read(graphqlClientProvider));
    final values = (await convertStateToInputs(encryptionKey)).toList();

    final result = await client.mutate_AusfuehrungFortsetzen(
      Options_Mutation_AusfuehrungFortsetzen(
        variables: Variables_Mutation_AusfuehrungFortsetzen(
          input: Input_AusfuehrungContinueInput(
            ausfuehrungId: _state.ausfuehrungId!,
            bearbeitungen: values,
          ),
        ),
      ),
    );

    final ausfuehrungResult =
        result.parsedData?.ausfuehrungContinue.ausfuehrungResult;

    if (ausfuehrungResult != null && ausfuehrungResult.shouldContinue) {
      await continueAusfuehrung(
        id: ausfuehrungResult.ausfuehrung.id,
        keepAusfuehrungKey: true,
      );
      return;
    }

    state = _state.copyWith(
      clientStatus: result.hasException
          ? AntragClientStatus.errorSubmitting
          : AntragClientStatus.submitted,
    );

    ref.invalidate(ausfuehrungProvider);
  }

  /// Creates a new execution with encrypted keys and transfers the data.
  @override
  Future<void> ausfuehrungCreate() async {
    final buergerPublicKey = ref.read(authProvider).publicKey;
    final buergerPrivatKey = ref.read(authProvider).privateKey;
    if (buergerPublicKey == null) {
      state = _state.copyWith(
        clientStatus: AntragClientStatus.errorKeyUnavailable,
      );
      return;
    }

    final kommune = _state.kommune;
    final kommunePublicKey = kommune.publicKey!;

    // Reuse the shared key across retries of the same Antrag instead of
    // generating a new one every attempt, so the existence check below can
    // actually recognize a previous attempt that succeeded server-side but
    // whose response the client never received (e.g. after a timeout).
    var sharedKeyEncryptedForBuerger = _state.sharedKeyEncryptedForBuerger;
    final Uint8List ausfuehrungKey;

    if (sharedKeyEncryptedForBuerger != null) {
      final cachedKey = _ausfuehrungKey;
      if (cachedKey != null) {
        ausfuehrungKey = cachedKey;
      } else if (buergerPrivatKey != null) {
        final unwrappedKey = _unwrapAusfuehrungKey(
          sharedKeyEncryptedForBuerger,
          buergerPrivatKey,
        );
        if (unwrappedKey == null) return;
        ausfuehrungKey = unwrappedKey;
      } else {
        state = _state.copyWith(
          clientStatus: AntragClientStatus.errorKeyUnavailable,
        );
        return;
      }
    } else {
      ausfuehrungKey = Crypto.getRandomKey();
      _ausfuehrungKey = ausfuehrungKey;
      sharedKeyEncryptedForBuerger = Crypto.wrapKey(
        ausfuehrungKey,
        buergerPublicKey,
      );
      state = _state.copyWith(
        sharedKeyEncryptedForBuerger: sharedKeyEncryptedForBuerger,
      );
    }

    final client = withAntragRequestTimeout(ref.read(graphqlClientProvider));

    // Single, best-effort check -- no retry loop, no delay. If it fails or
    // times out, we fall through and attempt a create anyway rather than
    // getting the Antrag permanently stuck.
    final existingExecutionId = await _findExistingExecutionId(
      client,
      sharedKeyEncryptedForBuerger,
    );
    if (existingExecutionId != null) {
      await continueAusfuehrung(
        id: existingExecutionId,
        keepAusfuehrungKey: true,
      );
      ref.invalidate(ausfuehrungProvider);
      return;
    }

    final sharedKeyEncryptedForKommune = Crypto.wrapKeyWithBase64(
      ausfuehrungKey,
      kommunePublicKey,
    );

    final values = (await convertStateToInputs(ausfuehrungKey)).toList();
    final result = await client.mutate_AusfuehrungErstellen(
      Options_Mutation_AusfuehrungErstellen(
        variables: Variables_Mutation_AusfuehrungErstellen(
          input: Input_AusfuehrungCreateInput(
            sharedKeyEncryptedForBuerger: sharedKeyEncryptedForBuerger,
            sharedKeyEncryptedForKommune: sharedKeyEncryptedForKommune,
            prozessVersionId: _state.prozessVersion.id,
            bearbeitungen: values,
          ),
        ),
      ),
    );

    final ausfuehrungResult =
        result.parsedData?.ausfuehrungCreate.ausfuehrungResult;
    if (ausfuehrungResult != null && ausfuehrungResult.shouldContinue) {
      await continueAusfuehrung(
        id: ausfuehrungResult.ausfuehrung.id,
        keepAusfuehrungKey: true,
      );
      return;
    }

    await client.refetchByName('MyMitteilungen');
    ref.invalidate(ausfuehrungProvider);

    state = _state.copyWith(
      clientStatus: result.hasException
          ? AntragClientStatus.errorSubmitting
          : AntragClientStatus.submitted,
    );
  }

  /// Looks up an already-created execution matching
  /// [encryptedCitizenSharedKey], if any -- so a retry after a lost response
  /// doesn't create a duplicate Ausführung. A single, best-effort check: on
  /// any failure (including a timeout) it returns null instead of throwing,
  /// so a flaky check never permanently blocks submission of this Antrag.
  Future<String?> _findExistingExecutionId(
    GraphQLClient client,
    String encryptedCitizenSharedKey,
  ) async {
    try {
      final existingRes = await client.query_Ausfuehrungen(
        Options_Query_Ausfuehrungen(fetchPolicy: FetchPolicy.networkOnly),
      );

      if (existingRes.hasException) return null;
      if (existingRes.parsedData?.my is! Query_Ausfuehrungen_my__Buerger) {
        return null;
      }

      final my = existingRes.parsedData!.my as Query_Ausfuehrungen_my__Buerger;
      return my.ausfuehrungen
          .firstWhereOrNull(
            (a) => a.sharedKeyEncryptedForBuerger == encryptedCitizenSharedKey,
          )
          ?.id;
    } catch (_) {
      return null;
    }
  }
}
