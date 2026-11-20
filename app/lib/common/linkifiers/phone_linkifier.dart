import 'package:linkify/linkify.dart';

final _phoneNumberRegex = RegExp(
  r'^(?<pre>.*?)(?<number>0[\d\-/\\ ]{6,}\d)(?<post>.*)',
  caseSensitive: false,
  dotAll: true,
);

/*
 * Linkify comes with its own PhoneNumberLinkifier but it does not support what
 *   we need (specifically a wider variety of digit delimiters), so we write our own
 */
/// Linkifier zur Erkennung und Verlinkung von Telefonnummern mit erweiterten Trennzeichen.
/// Ersetzt die führende Null durch die Ländervorwahl +49.
class PhoneNumberLinkifier extends Linkifier {
  const PhoneNumberLinkifier();

  /// Zerlegt eine Liste von LinkifyElementen und verlinkt erkannte Telefonnummern.
  /// [elements] sind die zu analysierenden Elemente, [options] steuern das Parsing.
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

      final match = _phoneNumberRegex.firstMatch(element.text);
      if (match == null) {
        list.add(element);
        continue;
      }

      final pre = match.namedGroup('pre')!;
      if (pre.isNotEmpty) {
        list.add(TextElement(pre));
      }

      final numberMatch = match.namedGroup('number')!;
      // Skip the 0 so we can replace it with +49
      final digitsOnly = numberMatch.replaceAll(RegExp(r'\D'), '').substring(1);

      list.add(LinkableElement(numberMatch, 'tel:+49$digitsOnly'));

      final post = match.namedGroup('post')!;
      list.addAll(parse([TextElement(post)], options));
    }

    return list;
  }
}
