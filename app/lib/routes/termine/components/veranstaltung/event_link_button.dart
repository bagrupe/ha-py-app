part of 'veranstaltungen_detail.dart';

/// Opens an event provider or ticket link in the external browser.
class _EventLinkButton extends StatelessWidget {
  /// Creates a link with an accessible text label.
  const _EventLinkButton(this.text, this.link);

  /// The localized button label.
  final String text;

  /// The external destination supplied by the backend.
  final String link;

  /// Shows a localized message if the event link cannot be opened.
  Future<void> _openLink(BuildContext context) async {
    if (await tryOpenExternalWebLink(link) || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('application.events.link_open_failed'.tr())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton(
        onPressed: () => _openLink(context),
        child: Text(text),
      ),
    );
  }
}
