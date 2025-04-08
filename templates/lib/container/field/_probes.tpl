{{- /* Probes used by the container. */ -}}
{{- define "2f.uchart.lib.container.field.probes" -}}
  {{- $ctx := .ctx -}}
  {{- $root := $ctx.root -}}
  {{- $workloadObject := $ctx.workloadObject -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- /* Default to empty dict */ -}}
  {{- $enabledProbes := dict -}}

  {{- range $probeName, $probeValues := $containerObject.probes -}}
    {{- /* Disable probe by default, but allow override */ -}}
    {{- $probeEnabled := false -}}
    {{- if hasKey $probeValues "enabled" -}}
      {{- $probeEnabled = $probeValues.enabled -}}
    {{- end -}}

    {{- if $probeEnabled -}}
      {{- $probeDefinition := dict -}}

      {{- if $probeValues.custom -}}
        {{- $parsedProbeSpec := include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" ($probeValues.spec | toYaml)) -}}
        {{- $probeDefinition = $parsedProbeSpec | fromYaml -}}
      {{- else -}}
        {{- $probeSpec := dig "spec" dict $probeValues -}}

        {{- $primaryService := include "2f.uchart.lib.service.utils.primaryForWorkload" (dict "root" $root "workloadId" $workloadObject.id) | fromYaml -}}
        {{- $primaryServiceDefaultPort := dict -}}
        {{- if $primaryService -}}
          {{- $primaryServiceDefaultPort = include "2f.uchart.lib.service.utils.primaryPort" (dict "root" $root "serviceObject" $primaryService) | fromYaml -}}
        {{- end -}}
        {{- if $primaryServiceDefaultPort -}}
          {{- $probeType := "" -}}
          {{- if eq $probeValues.type "AUTO" -}}
            {{- $probeType = $primaryServiceDefaultPort.protocol -}}
          {{- else -}}
            {{- $probeType = $probeValues.type | default "TCP" -}}
          {{- end -}}

          {{- $_ := set $probeDefinition "initialDelaySeconds" (include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $probeSpec.initialDelaySeconds "default" 0) | int) -}}
          {{- $_ := set $probeDefinition "failureThreshold" (include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $probeSpec.failureThreshold "default" 3) | int) -}}
          {{- $_ := set $probeDefinition "timeoutSeconds" (include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $probeSpec.timeoutSeconds "default" 1) | int) -}}
          {{- $_ := set $probeDefinition "periodSeconds" (include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $probeSpec.periodSeconds "default" 10) | int) -}}

          {{- $probeHeader := "" -}}
          {{- if or ( eq $probeType "HTTPS" ) ( eq $probeType "HTTP" ) -}}
            {{- $probeHeader = "httpGet" -}}

            {{- $_ := set $probeDefinition $probeHeader (
              dict
                "path" $probeValues.path
                "scheme" $probeType
              )
            -}}
          {{- else if (eq $probeType "GRPC") -}}
            {{- $probeHeader = "grpc" -}}
            {{- $_ := set $probeDefinition $probeHeader dict -}}
              {{- if $probeValues.service -}}
                {{- $_ := set (index $probeDefinition $probeHeader) "service" $probeValues.service -}}
              {{- end -}}
          {{- else -}}
            {{- $probeHeader = "tcpSocket" -}}
            {{- $_ := set $probeDefinition $probeHeader dict -}}
          {{- end -}}

          {{- if $probeValues.port -}}
            {{- $_ := set (index $probeDefinition $probeHeader) "port" $probeValues.port -}}
          {{- else if $primaryServiceDefaultPort.targetPort -}}
            {{- $_ := set (index $probeDefinition $probeHeader) "port" $primaryServiceDefaultPort.targetPort -}}
          {{- else -}}
            {{- $_ := set (index $probeDefinition $probeHeader) "port" ($primaryServiceDefaultPort.port) -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}

      {{- if $probeDefinition -}}
        {{- $_ := set $enabledProbes (printf "%sProbe" $probeName) $probeDefinition -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- with $enabledProbes -}}
    {{- . | toYaml -}}
  {{- end -}}
{{- end -}}
