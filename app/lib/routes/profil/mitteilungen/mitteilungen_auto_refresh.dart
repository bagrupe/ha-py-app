import 'dart:async';

import 'package:app/common/extensions/graphql_client.dart';
import 'package:app/graphql/graphql_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const mitteilungenRefreshInterval = Duration(seconds: 15);

class MitteilungenAutoRefresh extends ConsumerStatefulWidget {
  const MitteilungenAutoRefresh({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MitteilungenAutoRefresh> createState() =>
      _MitteilungenAutoRefreshState();
}

class _MitteilungenAutoRefreshState
    extends ConsumerState<MitteilungenAutoRefresh> {
  Timer? _timer;
  var _wasActive = false;

  void _refresh() {
    unawaited(ref.read(graphqlClientProvider).refetchByName('MyMitteilungen'));
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(mitteilungenRefreshInterval, (_) {
      if (TickerMode.valuesOf(context).enabled) _refresh();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = TickerMode.valuesOf(context).enabled;
    if (isActive && !_wasActive) _refresh();
    _wasActive = isActive;

    return widget.child;
  }
}
