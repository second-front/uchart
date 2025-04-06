{{- /* Set the nameOverride based on the release name if no override has been set */ -}}
{{- define "2f.uchart.values.setName" -}}
  {{- if not .Values.global.nameOverride -}}
    {{- $_ := set .Values.global "nameOverride" (.Values.global.applicationName | default .Release.Name) -}}
  {{- end -}}
{{- end -}}