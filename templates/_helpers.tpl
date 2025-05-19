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
{{- $name := default .Release.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" }}
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
Selector labels
*/}}
{{- define "universal-app-chart.selectorLabels" -}}
{{- if .Values.fullnameOverride -}}
app.kubernetes.io/name: {{ include "universal-app-chart.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- else -}}
app.kubernetes.io/name: {{ include "universal-app-chart.fullname" . }}
{{- end }}
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

{{- define "universal-app-chart.initContainersTagOverride" }}
- name: {{ .name }}
  {{- if .overrideTag }}
  image: {{ printf "%s:%s" (regexReplaceAll ":[^:]+$" .image "") .overrideTag }}
  {{- else }}
  image: {{ .image }}
  {{- end }}
  {{- if .command }}
  command:
    {{- toYaml .command | nindent 6 }}
  {{- end }}
  {{- if .args }}
  args:
    {{- toYaml .args | nindent 6 }}
  {{- end }}
  {{- if .env }}
  env:
    {{- range .env }}
    - name: {{ .name }}
      value: {{ .value }}
    {{- end }}
  {{- end }}
  {{- if .envFrom }}
  envFrom:
    {{- range .envFrom }}
      {{- if .configMapRef }}
    - configMapRef:
        name: {{ .configMapRef.name }}
      {{- end }}
      {{- if .secretRef }}
    - secretRef:
        name: {{ .secretRef.name }}
      {{- end }}
    {{- end }}
  {{- end }}
  {{- if .resources }}
  resources:
    {{- toYaml .resources | nindent 6 }}
  {{- end }}
  {{- if .volumeMounts }}
  volumeMounts:
    {{- toYaml .volumeMounts | nindent 6 }}
  {{- end }}
  {{- if .securityContext }}
  securityContext:
    {{- toYaml .securityContext | nindent 6 }}
  {{- end }}
  {{- if .terminationMessagePath }}
  terminationMessagePath: {{ .terminationMessagePath }}
  {{- end }}
  {{- if .terminationMessagePolicy }}
  terminationMessagePolicy: {{ .terminationMessagePolicy }}
  {{- end }}
  {{- if .stdin }}
  stdin: {{ .stdin }}
  {{- end }}
  {{- if .stdinOnce }}
  stdinOnce: {{ .stdinOnce }}
  {{- end }}
  {{- if .tty }}
  tty: {{ .tty }}
  {{- end }}
{{- end -}}
