{{ define "secretBase" }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ .component.name }}-secrets-{{ .root.Release.Name }}
data:
{{- range .root.Files.Lines .component.deployment.secrets }}
  {{- /* The next line prevents comments from being read */}}
  {{- /* TODO gracefully handle empty lines */}}
  {{-   if and . (hasPrefix "#" . | not) }}
  {{-     $parts := regexSplit "=" . 2 }}
  {{      index $parts 0  }}: {{ index $parts 1 | b64enc }}
  {{-   end }}
  {{- end }}
{{ end }}
