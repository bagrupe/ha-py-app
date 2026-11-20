{{ define "volumeBase" }}
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {{ .component.name }}-pvc-{{ .root.Release.Name }}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .component.deployment.volume.size }}
{{ end }}
