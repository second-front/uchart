{{- /* Initialize podDisruptionBudget values */ -}}
{{- define "2f.uchart.lib.podDisruptionBudget.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $pdbValues := .values -}}
  
  {{- /* Return the podDisruptionBudget object */ -}}
  {{- $pdbValues | toYaml -}}
{{- end -}}
