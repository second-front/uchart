{{- define "2f.uchart.legacy.namespace" -}}
{{- if .Values.argocd.createNamespace }}
{{- range .Values.argocd.sourceNamespaces }}

---
apiVersion: v1
kind: Namespace
metadata:
  name: {{ . }}
  labels:
    istio-injection: enabled
{{- end }}
{{- end }}
{{- end }}
