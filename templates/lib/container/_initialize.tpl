{{- /* Initialize container values */ -}}
{{- define "2f.uchart.lib.container.initialize" -}}
  {{- $root := .root -}}
  {{- $workloadObject := mustDeepCopy .workloadObject -}}
  {{- $containerType := .containerType -}}
  {{- $id := .id -}}
  {{- $objectValues := mustDeepCopy .values -}}
  {{- $defaultContainerOptionsStrategy := dig "defaultContainerOptionsStrategy" "overwrite" $workloadObject -}}
  {{- $mergeDefaultContainerOptions := true -}}

  {{- $_ := set $objectValues "id" $id -}}

  {{- /* Allow disabling default options for initContainers */ -}}
  {{- if (eq "init" $containerType) -}}
    {{- $applyDefaultContainerOptionsToInitContainers := dig "applyDefaultContainerOptionsToInitContainers" true $workloadObject -}}
    {{- if (not (eq $applyDefaultContainerOptionsToInitContainers true)) -}}
      {{- $mergeDefaultContainerOptions = false -}}
    {{- end -}}
  {{- end -}}

  {{- /* Merge default container options if required */ -}}
  {{- if (eq true $mergeDefaultContainerOptions) -}}
    {{- if eq "overwrite" $defaultContainerOptionsStrategy -}}
      {{- range $key, $defaultValue := (dig "defaultContainerOptions" dict $workloadObject) -}}
        {{- $specificValue := dig $key nil $objectValues -}}
        {{- if not (empty $specificValue) -}}
          {{- $_ := set $objectValues $key $specificValue -}}
        {{- else -}}
          {{- $_ := set $objectValues $key $defaultValue -}}
        {{- end -}}
      {{- end -}}
    {{- else if eq "merge" $defaultContainerOptionsStrategy -}}
      {{- $objectValues = merge $objectValues (dig "defaultContainerOptions" dict $workloadObject) -}}
    {{- end -}}
  {{- end -}}

  {{- /* Process image tags */ -}}
  {{- if kindIs "map" $objectValues.image -}}
    {{- $imageTag := dig "image" "tag" "" $objectValues -}}
    {{- /* Convert float64 image tags to string */ -}}
    {{- if kindIs "float64" $imageTag -}}
      {{- $imageTag = $imageTag | toString -}}
    {{- end -}}

    {{- /* Process any templates in the tag */ -}}
    {{- $imageTag = tpl $imageTag $root -}}

    {{- $_ := set $objectValues.image "tag" $imageTag -}}
  {{- end -}}

  {{- /* Return the container object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
