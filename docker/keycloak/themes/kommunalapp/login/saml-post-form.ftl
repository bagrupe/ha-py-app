<#--
  Überschreibt Keycloaks Standard-Template für die SAML-POST-Binding-Weiterleitung (theme/base/
  login/saml-post-form.ftl im keycloak-themes-Jar) — dieses wird für JEDE per SAML-POST-Binding
  verschickte Nachricht verwendet, also insbesondere für die AuthnRequest an BundID direkt nach
  "Mit BundID anmelden". Das Standard-Template rendert die volle Keycloak-Login-Seite (Header,
  Branding, "Redirecting..."-Text) drumherum, was im In-App-Browser kurz sichtbar aufblitzt, bevor
  das Formular sich automatisch abschickt. Diese Version zeigt bewusst NUR eine leere, weiße Seite
  ohne jeglichen Keycloak-Text, damit der Übergang zur BundID-Seite für den Nutzer nahtlos wirkt.
-->
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
    <style>html, body { margin: 0; padding: 0; background: #ffffff; }</style>
  </head>
  <body>
    <script>window.onload = function() { document.forms[0].submit(); };</script>
    <form name="saml-post-binding" method="post" action="${samlPost.url}">
      <#if samlPost.SAMLRequest??>
        <input type="hidden" name="SAMLRequest" value="${samlPost.SAMLRequest}"/>
      </#if>
      <#if samlPost.SAMLResponse??>
        <input type="hidden" name="SAMLResponse" value="${samlPost.SAMLResponse}"/>
      </#if>
      <#if samlPost.relayState??>
        <input type="hidden" name="RelayState" value="${samlPost.relayState}"/>
      </#if>
      <noscript>
        <input type="submit" value="${msg("doContinue")}"/>
      </noscript>
    </form>
  </body>
</html>
