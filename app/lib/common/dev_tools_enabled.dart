import 'package:flutter/foundation.dart';

/// Whether developer tools are available in the current build environment.
const devToolsEnabled =
    kDebugMode || String.fromEnvironment('SENTRY_ENVIRONMENT') == 'staging';
