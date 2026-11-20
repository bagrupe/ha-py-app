import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:linkify/linkify.dart';

final _emailRegex = RegExp(
  r'^(?<pre>.*?)(?<mail>(mailto:)?[A-Z0-9äöüß._%+-]+@[A-Z0-9äöüß.-]+\.[A-Zäöüß][A-Zäöüß]+)(?<post>.*)',
  caseSensitive: false,
  dotAll: true,
);

/*
 * Linkify comes with its own EmailLinkifier but it does not support what
 *   we need (specifically Umlauts), so we write our own
 */

/// Linkifier zur Erkennung und Verlinkung von E-Mail-Adressen inklusive Umlauten.
/// Ersetzt die Standard-EmailLinkifier-Implementierung, da diese keine Umlaute unterstützt.
class EmailLinkifier extends Linkifier {
  /// Erzeugt eine neue Instanz des EmailLinkifiers.
  const EmailLinkifier();

  /// Parst eine Liste von Linkify-Elementen und erkennt darin enthaltene E-Mail-Adressen.
  /// [elements] sind die zu parsenden Elemente, [options] die Parsing-Optionen.
  /// Gibt eine Liste von Linkify-Elementen zurück, in der E-Mail-Adressen als EmailElemente markiert sind.
  @override
  List<LinkifyElement> parse(
    List<LinkifyElement> elements,
    LinkifyOptions options,
  ) {
    final list = <LinkifyElement>[];

    for (final element in elements) {
      if (element is! TextElement) {
        list.add(element);
        continue;
      }

      final match = _emailRegex.firstMatch(element.text);

      if (match == null) {
        list.add(element);
        continue;
      }

      final pre = match.namedGroup('pre')!;
      if (pre.isNotEmpty) {
        list.add(TextElement(pre));
      }

      final mail = match.namedGroup('mail')!;
      list.add(EmailElement(mail));

      final post = match.namedGroup('post')!;
      list.addAll(parse([TextElement(post)], options));
    }

    return list;
  }
}
