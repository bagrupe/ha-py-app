{{- define "ingressBase" }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "composedName" . }}
  annotations:
    kubernetes.io/tls-acme: 'true'
    {{- if .root.Values.ingressWhitelistSourceRange }}
    nginx.ingress.kubernetes.io/denylist-source-range: "0.0.0.0/0, ::/0"
    nginx.ingress.kubernetes.io/whitelist-source-range: {{ .root.Values.ingressWhitelistSourceRange | quote }}
    nginx.ingress.kubernetes.io/use-forwarded-headers: "true"
    nginx.ingress.kubernetes.io/enable-real-ip: "true"
    {{- end }}
    {{- if .component.ingress.cors }}
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 10m
    {{- end }}
  labels: {{ include "k8s-helm.selectorLabels" (dict "root" .root "name" .component.name) | nindent 4 }}
spec:
  tls:
    - hosts:
        - "*.internal.example.invalid"
      secretName: wildcard-cert
  rules:
    - host: {{ .component.ingress.hostPrefix }}{{ if .component.ingress.hostPrefix }}-{{ end }}{{ .root.Release.Name }}.internal.example.invalid
      http:
        paths:
        {{- range .component.ingress.paths }}
          - path: {{ . }}
            pathType: Prefix
            backend:
              service:
                name: {{ include "composedName" $ }}
                port:
                  number: 80
        {{- end }}
{{- end }}
