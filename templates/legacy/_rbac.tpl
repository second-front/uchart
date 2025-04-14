{{- define "2f.uchart.legacy.rbac" -}}
{{- if and .Values.rbac.create .Values.rbac.rules }}
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: {{ include "universal-app-chart.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "universal-app-chart.labels" . | nindent 4 }}
rules:
  {{- toYaml .Values.rbac.rules | nindent 2 }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "universal-app-chart.fullname" . }}
  labels:
    {{- include "universal-app-chart.labels" . | nindent 4 }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: {{ include "universal-app-chart.fullname" . }}
subjects:
  - kind: ServiceAccount
    name: {{ include "universal-app-chart.serviceAccountName" . }}
    namespace: {{ .Release.Namespace | quote }}
{{- end }}
{{- end }}
