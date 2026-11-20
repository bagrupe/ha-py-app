import 'package:flutter_riverpod/legacy.dart';

enum HelpType {
  offerHelp, // "Ich biete Hilfe" -> Shows requests from others
  seekHelp, // "Ich suche Hilfe" -> Shows offers from others
}

final helpTypeProvider = StateProvider<HelpType>((ref) => HelpType.offerHelp);
