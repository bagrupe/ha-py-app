{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-helm.name" -}}
{{- .root.Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "k8s-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8s-helm.name" . }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
component: {{ .name }}
{{- end }}

{{/*
    Returns a docker image name built from this repo
    Requires a scope of { name: string; tag: string; }
*/}}
{{- define "exampleImage" -}}
registry.example.invalid:4567/example/kommunalapp/{{ .name }}:{{ .tag }}
{{- end }}

{{- define "composedName" -}}
{{ .component.name }}-{{ .root.Release.Name }}
{{- end }}
