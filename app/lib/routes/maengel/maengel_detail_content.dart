part of 'maengel_detail.dart';

class _MaengelDetail extends ConsumerStatefulWidget {
  const _MaengelDetail({required this.id});

  final String id;

  @override
  ConsumerState<_MaengelDetail> createState() => _MaengelDetailState();
}

class _MaengelDetailState extends ConsumerState<_MaengelDetail> {
  var _isToggling = false;

  String get _id => widget.id;

  Future<void> _updateTopic({required bool subscribe}) async {
    if (!isFirebasePushAvailable) return;

    try {
      if (subscribe) {
        await FirebaseMessaging.instance.subscribeToTopic('mangel-$_id');
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic('mangel-$_id');
      }
    } catch (e) {
      if (!kDebugMode) {
        rethrow;
      }
    }
  }

  Future<void> _toggleFolgen({required bool newFolgen}) async {
    final client = ref.read(graphqlClientProvider);

    final result = await client.mutate_MangelFolgen(
      Options_Mutation_MangelFolgen(
        variables: Variables_Mutation_MangelFolgen(
          input: Input_AusfuehrungFolgenInput(
            ausfuehrungId: _id,
            newFolgen: newFolgen,
          ),
        ),
      ),
    );

    if (result.hasException) {
      final isGone = result.exception?.graphqlErrors.isNotEmpty ?? false;
      if (isGone && !newFolgen) await _updateTopic(subscribe: false);
      if (mounted) {
        final key = isGone
            ? 'application.melder.maengel.follow_gone'
            : 'application.melder.maengel.follow_failed';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(key.tr())));
      }
      return;
    }

    await _updateTopic(subscribe: newFolgen);
    await client.refetchByName('MyMitteilungen');
  }

  Future<void> _onFolgenPressed({
    required bool newFolgen,
    required Future<void> Function()? refetch,
  }) async {
    setState(() => _isToggling = true);
    try {
      await _toggleFolgen(newFolgen: newFolgen);
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
    await refetch?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorTextTheme = theme.colorTextTheme;
    final kommuneId = ref.watch(appConfigProvider).kommuneId;
    final conf = ref.watch(appConfigProvider);
    final options = Options_Query_Mangel(
      pollInterval: const Duration(seconds: 15),
      variables: Variables_Query_Mangel(kommuneId: kommuneId, mangelId: _id),
    );

    final buergerId = ref.watch(authProvider).buergerId;

    return Query_Mangel_Widget(
      options: options,
      builder: (result, {fetchMore, refetch}) {
        final ausfuehrung = result.parsedData?.kommune.mangelAusfuehrung;

        if (ausfuehrung == null && result.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (result.hasException && ausfuehrung == null) {
          return ListErrorState(
            message: 'application.melder.maengel.detail_error'.tr(),
            onRetry: refetch,
          );
        }

        if (ausfuehrung == null) {
          return ListEmptyState(
            message: 'application.melder.maengel.not_found'.tr(),
          );
        }

        final mangel = Mangel.fromMaengelAusfuehrung(ausfuehrung);
        final istGefolgt = ausfuehrung.aktuellerNutzerFolgt;
        final historie = ausfuehrung.historie;

        return SingleChildScrollView(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 7,
                child: LoadingImage(
                  imageUrl: mangel.bilderSlotId != null
                      ? '${conf.backendUrl}/api/file/${mangel.bilderSlotId}/1080'
                      : null,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(mangel.kategorie, style: colorTextTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(mangel.title, style: textTheme.headlineMedium),
                    const SizedBox(height: 20),
                    if (mangel.adresse ?? mangel.coordinates?.formatted
                        case final adresse?) ...[
                      Text(
                        adresse,
                        style: textTheme.bodyLarge?.copyWith(
                          color: DesignTokens.gray500,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(mangel.beschreibung, style: textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 16),
                width: double.infinity,
                decoration: const BoxDecoration(color: DesignTokens.gray100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    'application.melder.history_title'.tr(),
                    style: textTheme.headlineSmall,
                  ),
                ),
              ),
              MangelHistorie(historie: historie),
              const SizedBox(height: 32),
              if (buergerId != null && ausfuehrung.userId != buergerId)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedButton(
                    onPressed: _isToggling
                        ? null
                        : () => _onFolgenPressed(
                            newFolgen: !istGefolgt,
                            refetch: refetch,
                          ),
                    child: Text(
                      istGefolgt
                          ? 'application.melder.maengel.unfollow'.tr()
                          : 'application.melder.maengel.follow'.tr(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
