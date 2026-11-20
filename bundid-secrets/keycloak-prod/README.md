# bundid-secrets/keycloak-prod/

Getrenntes RSA-4096-Schlüsselpaar (Signing + Encryption) für die BundID-**PROD**-Umgebung
(`https://id.bund.de/idp`), analog zu `bundid-secrets/keycloak/` für INT. Auch dieses
Verzeichnis ist bis auf diese README komplett von Git ausgeschlossen.

| Datei | Zweck |
|---|---|
| `bundid-saml-signing.crt` / `.key` | Signing-Zertifikat/-Schlüssel für PROD |
| `bundid-saml-encryption.crt` / `.key` | Encryption-Zertifikat/-Schlüssel für PROD |

**Wichtig:** Aktuell existiert in diesem Repo nur eine einzige Keycloak-Realm-Konfiguration
(`docker/keycloak/realm-kommunalapp.json`) mit einem IdP `bundid`, der fest auf
`https://int.id.bund.de` zeigt. Die hier abgelegten PROD-Zertifikate werden also noch von
nichts automatisch verwendet — dafür fehlt noch eine separate PROD-Realm-/IdP-Strategie
(offener Punkt, siehe Abschnitt 14 der ursprünglichen Doku: "getrennte INT-/PROD-Realm- oder
Instanzstrategie festlegen"). Die Dateien liegen hier bereit, bis dieser Schritt umgesetzt wird.

**Nicht vergessen bei der PROD-Realm-Einrichtung:** Die beiden Env-Vars
`KC_SPI_SAML_AUTHENTICATION_PREPROCESSOR_BUNDID_PROTOCOL_ENABLED_AUTHN_METHODS: benutzername` und
`KC_SPI_SAML_AUTHENTICATION_PREPROCESSOR_BUNDID_PROTOCOL_DISABLED_AUTHN_METHODS: eid,eidas,elster,authega,diia,fink`
(siehe `docker/docker-compose.local.yml`) müssen auch auf der PROD-Keycloak-Instanz gesetzt werden.
Sie schränken die von BundID angebotenen Anmeldewege bewusst auf Benutzername/Passwort ein, ohne
sie zeigt BundID zusätzlich Online-Ausweis/eID, EU-Identität etc. zur Auswahl an.
