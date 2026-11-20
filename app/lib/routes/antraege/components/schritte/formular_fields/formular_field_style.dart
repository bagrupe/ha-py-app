import 'package:flutter/material.dart';

const formularFieldBorderRadius = BorderRadius.all(Radius.circular(10));

Color highlightedFieldBackground(ThemeData theme) => Color.alphaBlend(
  theme.primaryColor.withValues(alpha: 0.08),
  theme.colorScheme.surface,
);
