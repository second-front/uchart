{{- /* Renders the serviceAccount object required by the chart. */ -}}
{{- define "2f.uchart.lib.serviceAccount.render" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.serviceAccounts -}}
  {{- $kind := "serviceAccount" -}}

  {{- /* Generate named serviceAccount objects as required */ -}}
  {{- $enabledServiceAccounts := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $serviceAccount := $enabledServiceAccounts -}}
    {{- $serviceAccountValues := (mustDeepCopy $serviceAccount) -}}

    {{- /* Create object from the raw ServiceAccount values */ -}}
    {{- $args := (dict "root" $root "id" $key "values" $serviceAccountValues "resources" $resources "kind" $kind) -}}
    {{- $serviceAccountObject := (include "2f.uchart.lib.utils.initialize" $args) | fromYaml -}}

    {{- /* Perform validations on the ServiceAccount before rendering */ -}}
    {{- include "2f.uchart.lib.serviceAccount.validate" (dict "root" $root "object" $serviceAccountObject) -}}

    {{- if not (hasKey $serviceAccountObject "workload") -}}
      {{- $_ := set ( get $root.Values.serviceAccounts $key) "workload" $key -}}
    {{- end -}}

    {{- /* Create a service account secret as required */ -}}
    {{- if $serviceAccountObject.createSecret -}}
      {{- $_ := set $.Values.secrets (printf "%s-sa-token" $serviceAccountObject.id)
        (dict 
          "enabled" true
          "annotations" (dict "kubernetes.io/service-account.name" $serviceAccountObject.name)
          "type" "kubernetes.io/service-account-token"
        )
      -}}
    {{- end -}}

    {{- /* Include the serviceAccount class */ -}}
    {{- include "2f.uchart.lib.serviceAccount.blueprint" (dict "root" $ "object" $serviceAccountObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
