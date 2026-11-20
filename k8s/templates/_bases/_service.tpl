{{ define "serviceBase" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "composedName" . }}
  labels: {{ include "k8s-helm.selectorLabels" (dict "root" .root "name" .component.name) | nindent 4 }}
spec:
  ports:
    {{- if kindIs "float64" .component.deployment.port }}
    - targetPort: http
      port: 80
    {{- else if .component.deployment.port}}
    - targetPort: {{ default "service" .component.deployment.port.name }}
      port: {{ .component.deployment.port.number }}
    {{- else if .component.deployment.ports }}
    {{- range .component.deployment.ports }}
    - targetPort: {{ .name }}
      port: {{ .number }}
      name: {{ .name }}
    {{- end }}
    {{- end }}
  selector: {{ include "k8s-helm.selectorLabels" (dict "root" .root "name" .component.name) | nindent 4 }}
{{- end }}
