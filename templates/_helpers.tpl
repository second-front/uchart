{{/*
Expand the name of the chart.
*/}}
{{- define "universal-app-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "universal-app-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "universal-app-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "universal-app-chart.labels" -}}
helm.sh/chart: {{ include "universal-app-chart.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
argocd.argoproj.io/instance: {{ .Values.global.applicationName }}
app.gamewarden.io/customerName: {{required ".Values.global.customerName is required" .Values.global.customerName}}
app.gamewarden.io/impactLevel: {{required ".Values.global.impactLevel is required" .Values.global.impactLevel}}
app.gamewarden.io/environment: {{required ".Values.global.environment is required" .Values.global.environment}}
{{- end }}

{{/*
Istio Labels
*/}}
{{- define "universal-app-chart.istioLabels" -}}
authentication: istio-auth
{{- end }}

{{/*
Selector labels
*/}}
{{- define "universal-app-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "universal-app-chart.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "universal-app-chart.serviceAccountName" -}}
{{ $create := index . 0 }}
{{- $name := index . 1 }}
{{- with index . 2 }}
{{- if $create }}
{{- default (include "universal-app-chart.name" .) $name }}
{{- else }}
{{- default "default" $name }}
{{- end }}
{{- end }}
{{- end }}

{{/*Set imagePullSecrets*/}}
{{- define "PullSecrets" }}
{"auths": {
{{- range .Values.imageCredentials }}
    {{ .registry | quote }}: {
      "username": {{ .username | quote }},
      "password": {{ .password | quote }},
      {{- if .email }}
      "email": {{ .email | quote }},
      {{- end }}
      "auth": {{ (print .username ":" .password) | b64enc | quote }}
    },
{{- end }}
}}
{{- end }}

{{/*
Remove the last commas after the last auth and base64 it
*/}}
{{- define "globalImagePullSecrets" -}}
{{ include "PullSecrets" . | toJson | replace "\\n" ""| replace " " "" | replace ",}}\"" "}}" | replace "\"{" "{" | replace "\\" "" | b64enc }}
{{- end }}
