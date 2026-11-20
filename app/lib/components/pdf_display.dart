import 'package:flutter/material.dart';

/// Ein Widget, das ein zentriertes PDF-Symbol mit Rahmen anzeigt.
class PDFDisplay extends StatelessWidget {
  /// Erstellt eine Instanz von PDFDisplay.
  const PDFDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Icon(
        Icons.picture_as_pdf_outlined,
        color: Colors.red,
        size: 48,
      ),
    );
  }
}
