{{- /* Resource builder for the chart */ -}}
{{- define "2f.uchart.loader.legacyResources" -}}
  {{- include "2f.uchart.legacy.argoWrapper.appInOne" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.argoWrapper.application" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.argoWrapper.project" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.argoWrapper.subCharts" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.networkPolicies.appPolicies" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.networkPolicies.customPolicies" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.istio.mtls" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.configMap" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.cronJob" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.daemonSet" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.deployment" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.extraManifests" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.generatedSecrets" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.imageCredentials" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.hpa" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.job" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.msvc.configMaps" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.msvc.secrets" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.multiContainer.daemonSet" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.multiContainer.deployment" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.multiContainer.statefulSet" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.namespace" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.pdbs" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.rbac" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.secrets" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.secretGenerationJob" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.service" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.serviceAccount" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.statefulSet" . | nindent 0 -}}
  {{- include "2f.uchart.legacy.virtualService" . | nindent 0 -}}
{{- end -}}
