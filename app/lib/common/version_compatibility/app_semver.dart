/// Vergleicht App-Versionsstrings im Format `major.minor.patch` (optionaler Build nach `+` wird ignoriert).
int compareAppReleaseVersions(String a, String b) {
  final pa = _parseReleaseTriple(_stripBuildMetadata(a));
  final pb = _parseReleaseTriple(_stripBuildMetadata(b));
  for (var i = 0; i < 3; i++) {
    final c = pa[i].compareTo(pb[i]);
    if (c != 0) {
      return c;
    }
  }
  return 0;
}

/// `true`, wenn [appVersion] nicht kleiner als [minimumRequired] ist (siehe [compareAppReleaseVersions]).
bool isAppVersionCompatible(String appVersion, String minimumRequired) =>
    compareAppReleaseVersions(appVersion, minimumRequired) >= 0;

String _stripBuildMetadata(String v) {
  final plus = v.indexOf('+');
  return plus == -1 ? v : v.substring(0, plus);
}

List<int> _parseReleaseTriple(String v) {
  final parts = v.split('.');
  int part(int i) {
    if (i >= parts.length) {
      return 0;
    }
    final raw = parts[i].trim();
    final match = RegExp(r'^(\d+)').firstMatch(raw);
    return match == null ? 0 : int.tryParse(match.group(1)!) ?? 0;
  }

  return [part(0), part(1), part(2)];
}
