import 'package:app/common/color.dart';
import 'package:app/common/design_tokens.dart';
import 'package:app/common/kommune.dart';
import 'package:app/graphql/__generated__/kommune.graphql.dart';
import 'package:dynamic_fonts/dynamic_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Erzeugt ein ThemeData basierend auf dem übergebenen Design der Kommune.
/// [design] enthält die Designinformationen wie Farben und Schriftarten.
/// Gibt ein ThemeData zurück, das für die App verwendet wird.
ThemeData createTheme(Fragment_KommuneDesign? design) {
  final defaults = ThemeData.fallback(useMaterial3: true);
  final colors = design?.colors;
  final primaryColorHex = colors?.primary;
  final primaryLightColorHex = colors?.primaryLight;
  final bodyFontFamily = design?.fonts?.body;
  final headingsFontFamily = design?.fonts?.headings;

  final primaryColor = primaryColorHex != null
      ? colorFromHex(primaryColorHex)
      : DesignTokens.gray500;
  final primaryLightColor = primaryLightColorHex != null
      ? colorFromHex(primaryLightColorHex)
      : DesignTokens.gray300;

  final buttonBorderRadius = BorderRadius.circular(8);

  final body = bodyFontFamily != null
      ? DynamicFonts.getTextTheme(bodyFontFamily.name)
      : defaults.textTheme;
  final headings = headingsFontFamily != null
      ? DynamicFonts.getTextTheme(headingsFontFamily.name)
      : defaults.textTheme;

  return ThemeData(
    useMaterial3: false,
    primaryColor: primaryColor,
    primaryColorLight: primaryLightColor,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
    extensions: [
      HPTextTheme(
        // H1 - displayLarge (Century Gothic, Bold, 46px)
        displayLargeHP: headings.displayLarge!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 46,
          color: DesignTokens.gray900,
        ),
        // H2 - displayMedium (Century Gothic, Bold, 35px)
        displayMediumHP: headings.displayMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 35,
          color: DesignTokens.gray900,
        ),
        // H3 - displaySmall (Century Gothic, Bold, 27px)
        displaySmallHP: headings.displaySmall!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 27,
          color: DesignTokens.gray900,
        ),
        // Fallback with inherited value
        headlineLargeHP: headings.headlineLarge!.copyWith(
          color: DesignTokens.gray900,
        ),
        // H4 - headlineMedium (Century Gothic, Bold, 21px)
        headlineMediumHP: headings.headlineMedium!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 21,
          color: DesignTokens.gray900,
        ),
        // H5 - headlineSmall (Century Gothic, Bold, 16px)
        headlineSmallHP: headings.headlineSmall!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: DesignTokens.gray900,
        ),
        // H6 - titleLarge (Century Gothic, Regular, 12px)
        titleLargeHP: headings.titleLarge!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: DesignTokens.gray900,
        ),
        titleMediumHP: headings.titleMedium!.copyWith(
          color: DesignTokens.gray900,
        ),
        titleSmallHP: headings.titleSmall!.copyWith(
          color: DesignTokens.gray900,
        ),

        // Subline - bodyLarge (Century Gothic, Bold, 16px)
        bodyLargeHP: body.bodyLarge!.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: DesignTokens.gray900,
        ),
        bodyMediumHP: body.bodyMedium!.copyWith(color: DesignTokens.gray900),
        // Body - bodysmall (Century Gothic, Regular, 16px)
        bodySmallHP: body.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: DesignTokens.gray900,
        ),
      ),
    ],
    textTheme: body
        .apply(bodyColor: DesignTokens.gray900)
        .copyWith(
          displayLarge: headings.displayLarge!.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 46,
          ),
          displayMedium: headings.displayMedium!.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 35,
          ),
          displaySmall: headings.displaySmall!.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 27,
          ),
          headlineMedium: headings.headlineMedium!.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 21,
            color: DesignTokens.gray900,
          ),
          headlineSmall: headings.headlineSmall!.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: DesignTokens.gray900,
          ),
          titleLarge: headings.titleLarge!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          bodySmall: body.bodySmall!.copyWith(
            fontSize: 16,
            color: DesignTokens.gray900,
          ),
          bodyLarge: body.bodyLarge!.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
    splashColor: primaryColor.withAlpha(150),
    appBarTheme: AppBarTheme(
      iconTheme: defaults.iconTheme.copyWith(color: Colors.black),
      backgroundColor: Colors.white,
      titleTextStyle: headings.titleMedium!.copyWith(
        fontWeight: FontWeight.bold,
      ),
    ),
    badgeTheme: BadgeThemeData(
      textColor: primaryColor,
      backgroundColor: primaryLightColor,
    ),
    dividerColor: DesignTokens.gray300,
    dividerTheme: const DividerThemeData(
      color: DesignTokens.gray300,
      thickness: 1,
      space: 0,
    ),
    iconTheme: IconThemeData(color: primaryColor),
    datePickerTheme: const DatePickerThemeData(
      rangePickerHeaderForegroundColor: DesignTokens.black,
      rangePickerBackgroundColor: DesignTokens.white,
    ),
    listTileTheme: defaults.listTileTheme.copyWith(
      textColor: DesignTokens.gray900,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        side: BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: const CircleBorder(),
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(color: primaryColor),
      ),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? primaryLightColor
            : DesignTokens.gray300,
      ),
      checkColor: WidgetStateProperty.resolveWith((states) => Colors.black),
      visualDensity: VisualDensity.compact,
      // TODO: Fix checkmark size being too big
    ),
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintStyle: TextStyle(color: Colors.grey),
      isDense: true,
      border: OutlineInputBorder(),
      labelStyle: TextStyle(color: Colors.black),
    ),
    focusColor: Colors.transparent,
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? primaryColor
            : DesignTokens.gray300,
      ),
    ),
  );
}

/// Provider, der das Theme basierend auf dem aktuellen Design der Kommune bereitstellt.
final themeProvider = Provider((ref) {
  final design = ref.watch(kommuneProvider).value?.design;
  return createTheme(design);
});

@immutable
class HPTextTheme extends ThemeExtension<HPTextTheme> {
  const HPTextTheme({
    this.displayLargeHP,
    this.displayMediumHP,
    this.displaySmallHP,
    this.headlineLargeHP,
    this.headlineMediumHP,
    this.headlineSmallHP,
    this.titleLargeHP,
    this.titleMediumHP,
    this.titleSmallHP,
    this.bodyLargeHP,
    this.bodyMediumHP,
    this.bodySmallHP,
    this.labelLargeHP,
    this.labelMediumHP,
    this.labelSmallHP,
  });
  final TextStyle? displayLargeHP;
  final TextStyle? displayMediumHP;
  final TextStyle? displaySmallHP;
  final TextStyle? headlineLargeHP;
  final TextStyle? headlineMediumHP;
  final TextStyle? headlineSmallHP;
  final TextStyle? titleLargeHP;
  final TextStyle? titleMediumHP;
  final TextStyle? titleSmallHP;
  final TextStyle? bodyLargeHP;
  final TextStyle? bodyMediumHP;
  final TextStyle? bodySmallHP;
  final TextStyle? labelLargeHP;
  final TextStyle? labelMediumHP;
  final TextStyle? labelSmallHP;

  @override
  HPTextTheme copyWith({
    TextStyle? displayLargeHP,
    TextStyle? displayMediumHP,
    TextStyle? displaySmallHP,
    TextStyle? headlineLargeHP,
    TextStyle? headlineMediumHP,
    TextStyle? headlineSmallHP,
    TextStyle? titleLargeHP,
    TextStyle? titleMediumHP,
    TextStyle? titleSmallHP,
    TextStyle? bodyLargeHP,
    TextStyle? bodyMediumHP,
    TextStyle? bodySmallHP,
    TextStyle? labelLargeHP,
    TextStyle? labelMediumHP,
    TextStyle? labelSmallHP,
  }) {
    return HPTextTheme(
      displayLargeHP: displayLargeHP ?? this.displayLargeHP,
      displayMediumHP: displayMediumHP ?? this.displayMediumHP,
      displaySmallHP: displaySmallHP ?? this.displaySmallHP,
      headlineLargeHP: headlineLargeHP ?? this.headlineLargeHP,
      headlineMediumHP: headlineMediumHP ?? this.headlineMediumHP,
      headlineSmallHP: headlineSmallHP ?? this.headlineSmallHP,
      titleLargeHP: titleLargeHP ?? this.titleLargeHP,
      titleMediumHP: titleMediumHP ?? this.titleMediumHP,
      titleSmallHP: titleSmallHP ?? this.titleSmallHP,
      bodyLargeHP: bodyLargeHP ?? this.bodyLargeHP,
      bodyMediumHP: bodyMediumHP ?? this.bodyMediumHP,
      bodySmallHP: bodySmallHP ?? this.bodySmallHP,
      labelLargeHP: labelLargeHP ?? this.labelLargeHP,
      labelMediumHP: labelMediumHP ?? this.labelMediumHP,
      labelSmallHP: labelSmallHP ?? this.labelSmallHP,
    );
  }

  @override
  HPTextTheme lerp(ThemeExtension<HPTextTheme>? other, double t) {
    if (other is! HPTextTheme) return this;
    return HPTextTheme(
      displayLargeHP: TextStyle.lerp(displayLargeHP, other.displayLargeHP, t),
      displayMediumHP: TextStyle.lerp(
        displayMediumHP,
        other.displayMediumHP,
        t,
      ),
      displaySmallHP: TextStyle.lerp(displaySmallHP, other.displaySmallHP, t),
      headlineLargeHP: TextStyle.lerp(
        headlineLargeHP,
        other.headlineLargeHP,
        t,
      ),
      headlineMediumHP: TextStyle.lerp(
        headlineMediumHP,
        other.headlineMediumHP,
        t,
      ),
      headlineSmallHP: TextStyle.lerp(
        headlineSmallHP,
        other.headlineSmallHP,
        t,
      ),
      titleLargeHP: TextStyle.lerp(titleLargeHP, other.titleLargeHP, t),
      titleMediumHP: TextStyle.lerp(titleMediumHP, other.titleMediumHP, t),
      titleSmallHP: TextStyle.lerp(titleSmallHP, other.titleSmallHP, t),
      bodyLargeHP: TextStyle.lerp(bodyLargeHP, other.bodyLargeHP, t),
      bodyMediumHP: TextStyle.lerp(bodyMediumHP, other.bodyMediumHP, t),
      bodySmallHP: TextStyle.lerp(bodySmallHP, other.bodySmallHP, t),
      labelLargeHP: TextStyle.lerp(labelLargeHP, other.labelLargeHP, t),
      labelMediumHP: TextStyle.lerp(labelMediumHP, other.labelMediumHP, t),
      labelSmallHP: TextStyle.lerp(labelSmallHP, other.labelSmallHP, t),
    );
  }
}
