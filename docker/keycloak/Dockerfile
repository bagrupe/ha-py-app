# Lokales Keycloak-Image für die BundID-Anbindung (Identity Broker + SAML Service Provider).
#
# Das BundID-Keycloak-Extension-JAR (de.arbeitsagentur.opdt:keycloak-extension-bundid) wird
# bewusst NICHT hier heruntergeladen/gebacken, sondern zur Laufzeit per Bind-Mount aus
# bundid-secrets/keycloak/ eingehängt (siehe docker-compose.local.yml). So kann ein lokal
# korrigiertes JAR ausgetauscht werden, ohne dieses Image neu zu bauen.
FROM quay.io/keycloak/keycloak:26.6.3

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
