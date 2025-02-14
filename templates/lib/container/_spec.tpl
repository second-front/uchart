{{- /* The container spec definition for a pod. */ -}}
{{- define "2f.uchart.lib.container.spec" -}}
  {{- $root := .root -}}
  {{- $workloadObject := .workloadObject -}}
  {{- $containerObject := .containerObject -}}
  {{- $ctx := dict "root" $root "workloadObject" $workloadObject "containerObject" $containerObject -}}

name: {{ include "2f.uchart.lib.container.field.name" (dict "ctx" $ctx) | trim }}
image: {{ include "2f.uchart.lib.container.field.image" (dict "ctx" $ctx) | trim }}
  {{- with $containerObject.image.pullPolicy }}
imagePullPolicy: {{ . | trim }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.container.field.command" (dict "ctx" $ctx) | trim) }}
command: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.container.field.args" (dict "ctx" $ctx) | trim) }}
args: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $containerObject.securityContext }}
securityContext: {{ toYaml . | trim | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.container.field.env" (dict "ctx" $ctx) | trim) }}
env: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.container.field.envFrom" (dict "ctx" $ctx) | trim) }}
envFrom: {{ . | trim | nindent 2 }}
  {{- end -}}
  {{- with $containerObject.ports }}
ports: {{ toYaml . | trim | nindent 2 }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.container.field.probes" (dict "ctx" $ctx) | trim) }}
    {{- . | trim | nindent 0 -}}
  {{- end -}}
  {{- with $containerObject.resources }}
resources: {{ toYaml . | trim | nindent 2 }}
  {{- end -}}
  {{- with $containerObject.restartPolicy }}
restartPolicy: {{ . | trim }}
  {{- end -}}
  {{- with (include "2f.uchart.lib.container.field.volumeMounts" (dict "ctx" $ctx) | trim) }}
volumeMounts: {{ . | trim | nindent 2 }}
  {{- end -}}
{{- end -}}
