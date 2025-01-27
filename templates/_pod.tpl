{{- define "podTemplate" -}}
{{- $v := .v -}}
{{- $global := .global -}}
{{- $additionalPorts := (($v.service).additionalPorts) | default .Values.defaults.service.additionalPorts -}}
{{- $name := (($v.service).name) | default .Values.defaults.service.name -}}
{{- $port := (($v.service).port) | default .Values.defaults.service.port -}}
{{- $targetPort := (($v.service).targetPort) | default .Values.defaults.service.targetPort -}}
{{- $type := (($v.service).type) | default .Values.defaults.service.type -}}
{{- $affinity := $v.affinity | default .Values.defaults.affinity -}}
{{- $args := $v.args -}}
{{- $command := $v.command -}}
{{- $envs := $v.envs -}}
{{- $extraEnvs := $v.extraEnvs | default .Values.defaults.extraEnvs -}}
{{- $extraVolumeMounts := $v.volumeMounts | default .Values.defaults.volumeMounts -}}
{{- $extraVolumes := $v.volumes | default .Values.defaults.volumes -}}
{{- $imagePullPolicy := (($v.image).pullPolicy) | default .Values.defaults.image.pullPolicy -}}
{{- $imagePullSecrets := $v.imagePullSecrets | default .Values.defaults.imagePullSecrets -}}
{{- $initContainers := $v.initContainers}}
{{- $lifecycle := $v.lifecycle -}}
{{- $livenessProbe := $v.livenessProbe -}}
{{- $nodeSelector := $v.nodeSelector | default .Values.defaults.nodeSelector -}}

{{- $defaultPodSecurityContext := .Values.defaults.podSecurityContext | default dict }}
{{- $customPodSecurityContext := $v.podSecurityContext | default dict }}
{{- $mergedPodSecurityContext := mergeOverwrite $defaultPodSecurityContext $customPodSecurityContext }}
{{- $readinessProbe := $v.readinessProbe -}}
{{- $resources := $v.resources | default .Values.defaults.resources -}}
{{- $restartPolicy := $v.restartPolicy -}}
{{- $defaultSecurityContext := .Values.defaults.securityContext | default dict }}
{{- $customSecurityContext := $v.securityContext | default dict }}
{{- $mergedSecurityContext := mergeOverwrite $defaultSecurityContext $customSecurityContext }}
{{- $selectorLabels := $v.selectorLabels }}
{{- $serviceAccountName := (($v.serviceAccount).name) | default .Values.defaults.serviceAccount.name -}}
{{- $serviceEnabled := (($v.service).enabled) | default .Values.defaults.service.enabled -}}
{{- $startupProbe := $v.startupProbe -}}
{{- $terminationGracePeriodSeconds := $v.terminationGracePeriodSeconds -}}
{{- $tolerations := $v.tolerations | default .Values.defaults.tolerations -}}
{{- $topologySpreadConstraints := $v.topologySpreadConstraints -}}
{{- $workingDir := $v.workingDir -}}
{{- $mergedEnvFrom := $v.envFrom | default (list) }}
{{- $defaultsEnvFrom := .Values.defaults.envFrom | default (list) }}
{{- range $defaultsEnvFrom }}
  {{- $mergedEnvFrom = append $mergedEnvFrom . }}
{{- end }}
metadata:
  {{- if $v.podAnnotations }}
  annotations:
    {{- toYaml $v.podAnnotations | nindent 4 }}
  {{- end }}
  labels:
    app: {{ .appLabel | default .msvc }}
    {{- include "universal-app-chart.selectorLabels" $global | nindent 4 }}
    {{- include "universal-app-chart.istioLabels" $global | nindent 4 }}
    {{- if .labels -}} {{- toYaml .labels | nindent 4 }} {{- end }}
    {{- if $selectorLabels -}} {{- toYaml $selectorLabels | nindent 4 }} {{- end }}
    {{- include "universal-app-chart.labels" $global | nindent 4 }}
spec:
  {{- if $imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml $imagePullSecrets | nindent 4 }}
  {{- end }}
  serviceAccountName: {{ $serviceAccountName }}
  {{- with $initContainers }}
  initContainers:
    {{- $foundOverrideTag := false -}}
    {{- range $container := $initContainers }}
      {{- if hasKey $container "overrideTag" }}
        {{- $foundOverrideTag = true }}
      {{- end }}
    {{- end }}
    {{- if $foundOverrideTag }}
      {{- range $container := $initContainers }}
          {{- include "universal-app-chart.initContainersTagOverride" $container | nindent 6 }}
      {{- end }}
    {{- else }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  securityContext:
    {{- toYaml $mergedPodSecurityContext | nindent 4 }}
  terminationGracePeriodSeconds: {{ default 15 $terminationGracePeriodSeconds | int }}
  {{- if or (($v.cronjob).enabled) (($v.job).enabled) }}
  restartPolicy: {{ default "Never" $restartPolicy }}
  {{- else if $restartPolicy }}
  restartPolicy: {{ $restartPolicy }}
  {{- end }}
  containers:
    - name: {{ .msvc }}
      securityContext:
        {{- toYaml $mergedSecurityContext | nindent 8 }}
      image: {{ include "uchart.image" (dict "msvc" .msvc "image" .image "Values" .Values) }}
      {{- if $workingDir }}
      workingDir: {{ $workingDir }}
      {{- end }}
      {{- if $livenessProbe }}
      livenessProbe:
        {{- toYaml $livenessProbe | nindent 8 }}
      {{- end }}
      {{- if $readinessProbe }}
      readinessProbe:
        {{- toYaml $readinessProbe | nindent 8 }}
      {{- end }}
      {{- if $startupProbe }}
      startupProbe:
        {{- toYaml $startupProbe | nindent 8 }}
      {{- end }}
      {{- if $command }}
      command:
        {{- toYaml $command | nindent 8 }}
      {{- end }}
      {{- if $args }}
      args:
        {{- toYaml $args | nindent 8 }}
      {{- end }}
      imagePullPolicy: {{ $imagePullPolicy }}
      {{- if or ($mergedEnvFrom) ($v.config) ($v.secrets) }}
      envFrom:
      {{- toYaml $mergedEnvFrom | nindent 14 }}
      {{- end }}
      env:
        - name: "POD_NAME"
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: "POD_NAMESPACE"
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        {{- range $key, $value := $envs }}
        - name: {{ $key }}
          value: {{ $value | toString | quote }}
        {{- end }}
        {{- range $extraEnvs }}
        - name: {{ .name | quote }}
          {{- with .value }}
          value: {{ toYaml . }}
          {{- end -}}
          {{- if .valueFrom }}
          valueFrom:
          {{- .valueFrom | toYaml | nindent 12 }}
          {{- end -}}
        {{- end }}
      {{- if $extraVolumeMounts }}
      volumeMounts:
        {{- range $extraVolumeMounts }}
        - name: {{ .name | quote }}
          mountPath: {{ .mountPath | toYaml }}
          {{- if .subPath }}
          subPath: {{ .subPath | toYaml }}
          {{- end -}}
        {{- end }}
      {{- end }}
      resources:
        {{- toYaml $resources | nindent 8 }}
{{- if $serviceEnabled }}
      ports:
        - name: {{ $name }}
          containerPort: {{ $targetPort }}
          protocol: TCP
        {{- if $additionalPorts }}
        {{- range $additionalPorts }}
        - name: {{ .name }}
          containerPort: {{ .targetPort }}
          protocol: {{ .protocol -}}
        {{- end }}
        {{- end }}
{{- end }}
  {{- with $nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $affinity }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $tolerations }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- with $extraVolumes }}
  volumes:
    {{- toYaml . | nindent 4 }}
{{- end }}
{{- end }}
