{{- /* envFrom field used by the container. */ -}}
{{- define "2f.uchart.lib.container.field.envFrom" -}}
  {{- $ctx := .ctx -}}
  {{- $root := $ctx.root -}}
  {{- $containerObject := $ctx.containerObject -}}
  {{- $envFromValues := get $containerObject "envFrom" -}}
  {{- $configMapResources := $root.Values.configMaps -}}
  {{- $secretResources := $root.Values.secrets -}}

  {{- if not (empty $envFromValues) -}}
    {{- $envFrom := list -}}
    {{- range $envFromValues -}}
      {{- $item := dict -}}

      {{- if hasKey . "configMap" -}}
        {{- $configMap := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $configMapResources "id" .configMap) | fromYaml -}}
        {{- $configMapName := default (tpl .configMap $root) $configMap.name -}}
        {{- $_ := set $item "configMapRef" (dict "name" $configMapName) -}}
      {{- else if hasKey . "configMapRef" -}}
        {{- if not (empty (dig "id" nil .configMapRef)) -}}
          {{- $configMap := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $configMapResources "id" .configMapRef.id) | fromYaml -}}
          {{- if empty $configMap -}}
            {{- fail (printf "No configMap configured with id '%s'" .configMapRef.id) -}}
          {{- end -}}

          {{- $_ := set $item "configMapRef" (dict "name" $configMap.name) -}}
        {{- else -}}
          {{- $_ := set $item "configMapRef" (dict "name" (tpl .configMapRef.name $root)) -}}
        {{- end -}}

      {{- else if hasKey . "secret" -}}
        {{- $secret := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $secretResources "id" .secret) | fromYaml -}}
        {{- $secretName := default (tpl .secret $root) $secret.name -}}
        {{- $_ := set $item "secretRef" (dict "name" $secretName) -}}
      {{- else if hasKey . "secretRef" -}}
        {{- if not (empty (dig "id" nil .secretRef)) -}}
          {{- $secret := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $secretResources "id" .secretRef.id) | fromYaml -}}
          {{- if empty $secret -}}
            {{- fail (printf "No secret configured with id '%s'" .secretRef.id) -}}
          {{- end -}}

          {{- $_ := set $item "secretRef" (dict "name" $secret.name) -}}
        {{- else -}}
          {{- $_ := set $item "secretRef" (dict "name" (tpl .secretRef.name $root)) -}}
        {{- end -}}
      {{- end -}}

      {{- if not (empty (dig "prefix" nil .)) -}}
        {{- $_ := set $item "prefix" .prefix -}}
      {{- end -}}

      {{- if not (empty $item) -}}
        {{- $envFrom = append $envFrom $item -}}
      {{- end -}}
    {{- end -}}

    {{- $envFrom | toYaml -}}
  {{- end -}}
{{- end -}}
