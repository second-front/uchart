{{- /* Return a ServiceAccount Object by it's id. */ -}}
{{- define "2f.uchart.lib.serviceAccount.getById" -}}
  {{ $root := .root -}}
  {{ $id := .id -}}
  {{- if eq $id "default" -}}
    {{- $serviceAccount := deepCopy $root.Values.serviceAccount -}}
    {{- if and (eq ($serviceAccount.name) "") (not $serviceAccount.create ) -}}
      {{- $_ := set $serviceAccount "name" "default" -}}
    {{- end -}}
    {{- include "2f.uchart.lib.serviceAccount.valuesToObject" (dict "root" $root "id" "default" "values" $serviceAccount) -}}
  {{- else -}}
    {{- $serviceAccountValues := dig "extraServiceAccounts" $id nil $root.Values.serviceAccount -}}
    {{- if not (empty $serviceAccountValues) -}}
      {{- include "2f.uchart.lib.serviceAccount.valuesToObject" (dict "root" $root "id" $id "values" $serviceAccountValues) -}}
    {{- else -}}
      {{- fail (printf "No ServiceAccount configured with id: %s" $id) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
