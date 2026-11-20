import 'package:app/routes/profil/inhalte_und_benachrichtigungen/components/abfall.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'AbfallBenachrichtigungen', type: AbfallBenachrichtigungen)
Widget abfallBenachrichtigungen(BuildContext context) =>
    const AbfallBenachrichtigungen();
