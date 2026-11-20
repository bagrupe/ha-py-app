"""Regression checks for publication findings missed by generic secret signatures."""

import unittest

from publication_audit import patterns, scan


class PublicationAuditTests(unittest.TestCase):
    """Detect documented credentials and real contact data without exposing values."""

    def test_documented_hosted_credentials_are_flagged(self):
        """Recognize password labels in both supported documentation languages."""
        value = "Q7mN4pR9vS2x"
        for text in [f"Passwort: ${value}", f"Demo users (password `{value}`, all users)",
                     f'Passwort ist für jeden Nutzer "{value}"',
                     f"password for every user is `{value}`"]:
            with self.subTest(text_format=text.split()[0]):
                findings = list(scan("docs/setup.md", text.encode(), patterns()))
                self.assertEqual([f["category"] for f in findings], ["documented-password-review"])
                self.assertNotIn(value, str(findings))

    def test_separately_supplied_and_local_example_passwords_are_allowed(self):
        """Keep placeholder instructions and explicitly public local test values usable."""
        for text in ["Password: <provided-separately>", "local-only password `123456`"]:
            self.assertEqual(list(scan("README.md", text.encode(), patterns())), [])

    def test_category_import_rejects_non_example_email_addresses(self):
        """Catch contact addresses in the publication CSV independently of secret scans."""
        findings = list(scan("backend/API/Scripts/ImportKategorieBaum/baum.csv",
                             b"Example;Category;;person@municipality.invalid", patterns()))
        self.assertEqual([f["category"] for f in findings], ["non-example-contact"])

    def test_category_import_allows_reserved_example_addresses(self):
        """Accept the sanitized category import without weakening general key detection."""
        self.assertEqual(list(scan("backend/API/Scripts/ImportKategorieBaum/baum.csv",
                                  b"Example;Category;;kontakt@example.com", patterns())), [])


if __name__ == "__main__":
    unittest.main()
