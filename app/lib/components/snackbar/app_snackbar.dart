import 'package:flutter/material.dart';

/// Displays an accessible, consistently styled app-wide notification.
class AppSnackBar extends SnackBar {
  /// Creates a notification with an optional action.
  AppSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    super.duration = const Duration(seconds: 4),
    super.key,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'actionLabel and onAction must either both be set or both be null.',
       ),
       super(
         backgroundColor: Theme.of(context).colorScheme.inverseSurface,
         behavior: SnackBarBehavior.floating,
         margin: const EdgeInsets.all(16),
         content: Semantics(
           liveRegion: true,
           label: message,
           child: ExcludeSemantics(child: Text(message)),
         ),
         action: actionLabel == null
             ? null
             : SnackBarAction(
                 label: actionLabel,
                 textColor: Theme.of(context).colorScheme.inversePrimary,
                 onPressed: onAction!,
               ),
       );
}
