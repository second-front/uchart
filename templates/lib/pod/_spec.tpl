{{- /* The pod spec definition for a workload. */ -}}
{{- define "2f.uchart.lib.pod.spec" -}}
  {{- $root := .root -}}
  {{- $workloadObject := .workloadObject -}}
  {{- $ctx := dict "root" $root "workloadObject" $workloadObject -}}

serviceAccountName: {{ include "2f.uchart.lib.pod.field.serviceAccountName" (dict "ctx" $ctx) | trim }}
enableServiceLinks: {{ include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "enableServiceLinks" "default" false) }}
automountServiceAccountToken: {{ include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "automountServiceAccountToken" "default" true) }}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "priorityClassName")) }}
priorityClassName: {{ . | trim }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "runtimeClassName")) }}
runtimeClassName: {{ . | trim }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "securityContext")) }}
securityContext: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "imagePullSecrets")) }}
imagePullSecrets: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "restartPolicy")) }}
restartPolicy: {{ . | trim }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "nodeSelector")) }}
nodeSelector: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "affinity")) }}
affinity: {{- tpl . $root | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "topologySpreadConstraints")) }}
topologySpreadConstraints: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.getOption" (dict "ctx" $ctx "option" "tolerations")) }}
tolerations: {{ . | nindent 2 }}
  {{- end }}
  {{- with (include "2f.uchart.lib.pod.field.initContainers" (dict "ctx" $ctx) | trim) }}
initContainers: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.field.containers" (dict "ctx" $ctx) | trim) }}
containers: {{ . | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.pod.field.volumes" (dict "ctx" $ctx) | trim) }}
volumes: {{ . | nindent 2 }}
  {{- end -}}
{{- end -}}
