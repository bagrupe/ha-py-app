import 'dart:developer';

import 'package:app/common/shared_preferences.dart';
import 'package:app/routes/karte/karte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';

/// Wrapper widget for showcasing features.
/// Registers callbacks for starting, completing or dismissing the showcase.
class ShowcaseWrapper extends ConsumerStatefulWidget {
  const ShowcaseWrapper({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShowcaseWrapperState();
}

class _ShowcaseWrapperState extends ConsumerState<ShowcaseWrapper> {
  @override
  void initState() {
    super.initState();
    ShowcaseView.register(
      onStart: (index, key) {
        log('onStart: $index, $key');
      },
      onComplete: (index, key) {
        log('onComplete: $index, $key');
        ref.read(sharedPreferencesProvider).setBool(karteIntroShownKey, true);
      },
      onDismiss: (key) {
        debugPrint('Dismissed at $key');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
