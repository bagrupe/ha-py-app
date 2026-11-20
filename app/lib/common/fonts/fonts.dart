import 'dart:ui';

import 'package:dynamic_fonts/dynamic_fonts.dart';

/// Definiert die reguläre Schriftvariante mit normalem Gewicht und Stil.
const regular = DynamicFontsVariant(
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.normal,
);

/// Definiert die fette Schriftvariante mit starkem Gewicht und normalem Stil.
const bold = DynamicFontsVariant(
  fontWeight: FontWeight.w700,
  fontStyle: FontStyle.normal,
);

/// Definiert die leichte Schriftvariante mit geringem Gewicht und normalem Stil.
const light = DynamicFontsVariant(
  fontWeight: FontWeight.w300,
  fontStyle: FontStyle.normal,
);

// expectedFileHash is SHA256
// expectedLength is in bytes

/// Enthält eine Zuordnung von Schriftfamilien zu ihren Varianten mit erwarteten Hashes und Dateigrößen.
final Map<String, Map<DynamicFontsVariant, (String, int)>> fontsMap = {
  'Mulish': {
    regular: (
      '0f21476f6197950f976811ce610f2dc9f7dc10a4ea5aad2c75fa3d65c6b43b32',
      105860,
    ),
    bold: (
      '0d12a5128d541738d925cc8dda9630be3fd808ab8c04f19a8b83bcdebf64498a',
      105904,
    ),
    light: (
      '5d3abbca0e659db0482f75977e68073aa0691c2c253a9840178c33333a8f86eb',
      105916,
    ),
  },
  'NotoSans': {
    regular: (
      '2ec33f84606cbaa0a1a944488e14f97faf2f6a25ecdd8354f5358f06da13c7d9',
      556216,
    ),
    bold: (
      '8b6389d671315ddf9e50ab4419a3b8a40298b709a46e785a345ef2ecf473b8d6',
      557380,
    ),
    light: (
      '9ad3eac2298dcc17b94c76234e9308f73d02211b80322c28d0d8226d736b4317',
      554712,
    ),
  },
  'RobotoSlab': {
    regular: (
      '919f37a6657c45e8301e901f4773700cc6d413236eda44fc6fc5ff32ba5287b9',
      126524,
    ),
    bold: (
      '5c0832ac8f7a549ac4d327bed799ab659691c91fc962680a7915d81c6328eed9',
      127292,
    ),
    light: (
      '7a0b74ee767085dc0fa099824464c644bd09f1afc4390956a6e70f247498568e',
      126916,
    ),
  },
  'CenturyGothic': {
    regular: (
      '3a9cbb5d75b2a2b0d22dc94571608e4e9dc7b88e825374985880c5722c1c9e5f',
      137568,
    ),
    bold: (
      '90cb613b492874a560c0ff18a3402b1d24fb7e846dff11295d5c4644d6c75e83',
      129676,
    ),
    light: (
      '3a9cbb5d75b2a2b0d22dc94571608e4e9dc7b88e825374985880c5722c1c9e5f',
      137568,
    ),
  },
};

/// Registriert eine Schriftfamilie mit der Basis-URL für die Schriftdateien.
/// [family] ist der Name der Schriftfamilie, [baseUrl] die URL zum Speicherort der Dateien.
void registerFont(String family, String baseUrl) {
  final variantsMap = fontsMap[family];
  if (variantsMap == null) return;

  DynamicFonts.register(
    family,
    Map.fromEntries(
      variantsMap.entries.map((e) {
        final variant = e.key;
        final (expectedFileHash, expectedLength) = e.value;
        return MapEntry(
          variant,
          HostedFontFile(
            baseUrl,
            family,
            variant,
            expectedFileHash,
            expectedLength,
          ),
        );
      }),
    ),
  );
}

/// Repräsentiert eine gehostete Schriftdatei mit zugehörigen Metadaten.
class HostedFontFile extends DynamicFontsFile {
  /// Erstellt eine Instanz mit Basis-URL, Schriftfamilie, Variante, erwartetem Hash und Dateigröße.
  HostedFontFile(
    this.baseUrl,
    this.family,
    this.variant,
    super.expectedFileHash,
    super.expectedLength,
  );

  final String family;
  final String baseUrl;
  final DynamicFontsVariant variant;

  @override
  /// Liefert die URL zur Schriftdatei basierend auf Basis-URL, Familie und Variante.
  String get url =>
      '$baseUrl/$family/$family-${variant.toApiFilenamePart()}.ttf';
}
