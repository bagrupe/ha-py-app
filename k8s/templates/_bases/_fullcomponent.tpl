{{ define "fullComponent" }}
{{ if .component.ingress }}{{ include "ingressBase" . }}{{ end }}
---
{{ if .component.deployment }}
{{ include "serviceBase" . }}
---
{{ include "deploymentBase" . }}
---
{{ end }}
{{ end }}
