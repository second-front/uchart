{{- /* The pod containers definition for a workload. */ -}}
{{- define "2f.uchart.lib.pod.field.containers" -}}
  {{- $root := .ctx.root -}}
  {{- $workloadObject := .ctx.workloadObject -}}

  {{- /* Default to empty list */ -}}
  {{- $graph := dict -}}
  {{- $containers := list -}}

  {{- /* Fetch configured containers for this workload */ -}}
  {{- $enabledContainers := include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $workloadObject.containers) | fromYaml }}
  {{- $renderedContainers := dict -}}

  {{- range $key, $containerValues := $enabledContainers -}}
    {{- /* Create object from the container values */ -}}
    {{- $containerObject := (include "2f.uchart.lib.container.valuesToObject" (dict "root" $root "workloadObject" $workloadObject "containerType" "default" "id" $key "values" $containerValues)) | fromYaml -}}

    {{- /* Perform validations on the Container before rendering */ -}}
    {{- include "2f.uchart.lib.container.validate" (dict "root" $root "workloadObject" $workloadObject "containerObject" $containerObject) -}}

    {{- /* Generate the Container spec */ -}}
    {{- $renderedContainer := include "2f.uchart.lib.container.spec" (dict "root" $root "workloadObject" $workloadObject "containerObject" $containerObject) | fromYaml -}}
    {{- $_ := set $renderedContainers $key $renderedContainer -}}

    {{- /* Determine the Container order */ -}}
    {{- if empty (dig "dependsOn" nil $containerValues) -}}
      {{- $_ := set $graph $key ( list ) -}}
    {{- else if kindIs "string" $containerValues.dependsOn -}}
      {{- $_ := set $graph $key ( list $containerValues.dependsOn ) -}}
    {{- else if kindIs "slice" $containerValues.dependsOn -}}
      {{- $_ := set $graph $key $containerValues.dependsOn -}}
    {{- end -}}

  {{- end -}}

  {{- /* Process graph */ -}}
  {{- $args := dict "graph" $graph "out" list -}}
  {{- include "2f.uchart.lib.utils.kahn" $args -}}

  {{- range $name := $args.out -}}
    {{- $containerItem := get $renderedContainers $name -}}
    {{- $containers = append $containers $containerItem -}}
  {{- end -}}

  {{- if not (empty $containers) -}}
    {{- $containers | toYaml -}}
  {{- end -}}
{{- end -}}
