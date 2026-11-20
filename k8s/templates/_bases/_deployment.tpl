{{ define "deploymentBase" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "composedName" . }}
spec:
  selector:
    matchLabels: {{ include "k8s-helm.selectorLabels" (dict "root" .root "name" .component.name) | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "k8s-helm.selectorLabels" (dict "root" .root "name" .component.name) | nindent 8 }}
        # Force pulling of images if the tag was overwritten
        {{- if .component.deployment.image.example }}
        date: "{{ now | unixEpoch }}"
        {{- end }}
    spec:
      imagePullSecrets:
        - name: docker-registry
      {{- if .component.deployment.initContainers }}
      {{- $initYaml := .component.deployment.initContainers | toYaml }}
      {{- $templated := tpl $initYaml (dict "root" $.root "component" $.component "Template" $.root.Template) }}
      initContainers: {{ $templated | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ .component.name }}
          image: {{ if .component.deployment.image.example -}}
                {{ include "exampleImage" (dict "name" .component.deployment.image.name "tag" .root.Values.imageTag ) }}
            {{- else -}}
                {{ .component.deployment.image.tag }}
            {{- end }}
          imagePullPolicy: Always
          {{- if .component.deployment.resources }}
          resources: {{ .component.deployment.resources | toYaml | nindent 12 }}
          {{- end }}
          {{- if .component.deployment.startupProbe }}
          startupProbe: {{ .component.deployment.startupProbe | toYaml | nindent 12 }}
          {{- end }}
          ports:
          {{- if kindIs "float64" .component.deployment.port }}
            - name: http
              containerPort: {{ .component.deployment.port }}
          {{- else if .component.deployment.port}}
            - name: {{ default "service" .component.deployment.port.name }}
              containerPort: {{ .component.deployment.port.number }}
          {{- else if .component.deployment.ports }}
            {{- range .component.deployment.ports }}
            - name: {{ .name }}
              containerPort: {{ .number }}
            {{- end }}
          {{- end }}
{{- /*          TODO, maybe allow multiple secrets here? */}}
          {{- if .component.deployment.secrets }}
          envFrom:
            - secretRef:
                name: {{ .component.name }}-secrets-{{ .root.Release.Name }}
          {{- end }}
          env:
            - name: RELEASE_NAME
              value: {{ .root.Release.Name }}
          {{- if .component.deployment.env -}}
          {{- range .component.deployment.env }}
            - name: {{ .name }}
{{- /*            TODO fix opt-out of tpl */}}
              value: {{ if (default true .isTemplate) -}}
                {{ tpl .value (dict "root" $.root "component" $.component "Template" $.root.Template) }}
              {{- else }}
                {{ .value }}
              {{- end }}
          {{- end }}
          {{- end }}
          {{- if .component.deployment.volume }}
          volumeMounts:
            - name: {{ .component.name }}-volume
              mountPath: {{ .component.deployment.volume.mountPath }}
              {{- if .component.deployment.volume.subPath }}
              subPath: {{ .component.deployment.volume.subPath }}
              {{- end }}
          {{- end }}
      restartPolicy: Always
      {{- if .component.deployment.volume }}
      volumes:
        - name: {{ .component.name }}-volume
          persistentVolumeClaim:
            claimName: {{ .component.name }}-pvc-{{ .root.Release.Name }}
      {{- end }}

{{ if .component.deployment.secrets -}}
---
{{ include "secretBase" . }}
{{- end }}
{{ if .component.deployment.volume -}}
---
{{ include "volumeBase" . }}
{{- end }}
{{- end }}
