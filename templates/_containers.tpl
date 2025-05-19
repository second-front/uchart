{{- define "containerTemplate" -}}
{{- $v := .v -}}
{{- $global := .global -}}
{{- $additionalPorts := (($v.service).additionalPorts) | default .Values.defaults.service.additionalPorts -}}
{{- $name := (($v.service).name) | default .Values.defaults.service.name -}}
{{- $port := (($v.service).port) | default .Values.defaults.service.port -}}
{{- $targetPort := (($v.service).targetPort) | default .Values.defaults.service.targetPort -}}
{{- $type := (($v.service).type) | default .Values.defaults.service.type -}}
{{- $affinity := $v.affinity | default .Values.defaults.affinity }}
{{- $annotations := $v.annotations | default (dict) }}
{{- $createServiceAccount := (($v.serviceAccount).create) | default .Values.defaults.serviceAccount.create }}
{{- $extraVolumes := $v.volumes | default .Values.defaults.volumes }}
{{- $imagePullSecrets := $v.imagePullSecrets | default .Values.defaults.imagePullSecrets }}
{{- $initContainers := $v.initContainers}}
{{- $labels := $v.labels }}
{{- $livenessProbe := $v.livenessProbe }}
{{- $nodeSelector := $v.nodeSelector | default .Values.defaults.nodeSelector }}
{{- $podAnnotations := $v.podAnnotations | default .Values.defaults.podAnnotations }}
{{- $podSecurityContext := $v.podSecurityContext | default .Values.defaults.podSecurityContext }}
{{- $selectorLabels := $v.selectorLabels }}
{{- $serviceAccountName := (($v.serviceAccount).name) | default .Values.defaults.serviceAccount.name }}
{{- $terminationGracePeriodSeconds := $v.terminationGracePeriodSeconds }}
{{- $tolerations := $v.tolerations | default .Values.defaults.tolerations }}
{{- $topologySpreadConstraints := $v.topologySpreadConstraints }}
metadata:
  {{- with $podAnnotations }}
  annotations:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  labels:
    app: {{ .msvc }}
    {{- include "universal-app-chart.selectorLabels" $global | nindent 4 }}
    {{- if $labels -}} {{- toYaml $labels | nindent 4 }} {{- end }}
    {{- if $selectorLabels -}} {{- toYaml $selectorLabels | nindent 4 }} {{- end }}
    {{- include "universal-app-chart.labels" $global | nindent 4 }}
spec:
  {{- with $imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  serviceAccountName: {{ $serviceAccountName }}
  securityContext:
    {{- toYaml $podSecurityContext | nindent 8 }}
{{- if $initContainers }}
  initContainers:
  {{- with $initContainers -}}
    {{ tpl . $ | nindent 8 }}
  {{- end }}
{{- end }}
  terminationGracePeriodSeconds: {{ default 15 $terminationGracePeriodSeconds | int }}
  containers:
  {{- range $containerName, $container := $v.containers }}
    {{- with $container }}
    {{- $envs := $container.envs }}
    {{- $replicaCount := $container.replicaCount | default $.Values.defaults.replicaCount }}
    {{- $resources := $container.resources | default $.Values.defaults.resources }}
    {{- $serviceEnabled := (($container.service).enabled) | default $.Values.defaults.service.enabled }}
    {{- $securityContext := $container.securityContext | default $.Values.defaults.securityContext }}
    {{- $type := (($container.service).type) | default $.Values.defaults.service.type }}
    {{- $port := (($container.service).port) | default $.Values.defaults.service.port }}
    {{- $targetPort := (($container.service).targetPort) | default $.Values.defaults.service.targetPort }}
    {{- $name := (($container.service).name) | default $.Values.defaults.service.name }}
    {{- $additionalPorts := (($container.service).additionalPorts) | default $.Values.defaults.service.additionalPorts }}
    {{- $imagePullPolicy := $container.imagePullPolicy | default $.Values.defaults.image.pullPolicy }}
    - name: {{ $containerName }}
      securityContext:
        {{- toYaml $securityContext | nindent 12 }}
      image: {{ printf "%s/%s/%s:%s" $.Values.global.image.defaultImageRegistry $.Values.global.image.defaultImageRepository $container.image.name $container.image.tag }}
      {{- if $container.workingDir }}
      workingDir: {{ $container.workingDir }}
      {{- end }}
      {{- if $container.replicaCount }}
      replicas: {{ $container.replicaCount }}
      {{- end }}
      {{- with $container.livenessProbe }}
      livenessProbe:
      {{- toYaml . | nindent 12 }}
      {{- end }}
      {{- with $container.readinessProbe }}
      readinessProbe:
      {{- toYaml . | nindent 12 }}
      {{- end }}
      {{- with $container.startupProbe }}
      startupProbe:
      {{- toYaml . | nindent 12 }}
      {{- end }}
      {{- if $container.command }}
      command:
        {{- toYaml $container.command | nindent 12 }}
      {{- end }}
      {{- if $container.args }}
      args:
        {{- toYaml $container.args | nindent 12 }}
      {{- end }}
      imagePullPolicy: {{ $imagePullPolicy -}}
      {{- if $container.restartPolicy }}
      restartPolicy: {{ $container.restartPolicy }}
      {{- end -}}
      {{/* BACKWARD COMPATIBILITY FOR multi-lined piped string */}}
      {{- if or ($container.envFrom) ($v.config) ($v.secrets) -}}
      {{- if kindOf $container.envFrom | eq "string" }}
      envFrom:
      {{- range $line := splitList "\n" $container.envFrom }}
      {{- if ne $line "" }}
        {{- $line | nindent 12 }}
      {{- end }}
      {{- end }}
      {{- else }}
      envFrom:
        {{- if ($v.secrets) }}
        - secretRef:
            name: {{ .msvc }}-secret
        {{- end }}
        {{- if ($v.config) }}
        - configMapRef:
            name: {{ .msvc }}-config
        {{- end }}
      {{- if $container.envFrom }}
      {{- toYaml $container.envFrom | nindent 12 -}}
      {{- end }}
      {{- end }}
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
        - name: "NAMESPACE"
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
        - name: NODE_NAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        {{- range $key, $value := $envs }}
        - name: {{ $key }}
          value: {{ $value | toString | quote }}
        {{- end }}
        {{- range $container.extraEnvs }}
        - name: {{ .name | quote }}
          {{- if .value }}
          value: {{ .value | quote }}
          {{- end }}
          {{- if .valueFrom }}
          valueFrom:
            {{- .valueFrom | toYaml | nindent 16 }}
          {{- end }}
        {{- end }}
      {{- if $container.extraVolumeMounts }}
      volumeMounts:
      {{- range $container.extraVolumeMounts }}
        - name: {{ .name | quote }}
          mountPath: {{ .mountPath | toYaml }}
          {{- if .subPath }}
          subPath: {{ .subPath | toYaml }}
          {{- end -}}
      {{- end }}
      {{- end -}}
{{- if $serviceEnabled }}
      ports:
        - name: {{ $name }}
          containerPort: {{ $targetPort }}
          protocol: TCP
        {{- if $additionalPorts }}
        {{- range $additionalPorts }}
        - name: {{ .name }}
          containerPort: {{ .targetPort }}
          protocol: {{ .protocol }}
        {{- end }}
        {{- end }}
{{- end }}
      resources:
        {{- toYaml $resources | nindent 12 }}
    {{- end }}
  {{- end }}
  {{- with $nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- with $affinity }}
  affinity:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- with $topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- with $tolerations }}
  tolerations:
    {{- toYaml . | nindent 8 }}
  {{- end }}
{{- with $extraVolumes }}
  volumes:
    {{- toYaml . | nindent 4 }}
{{- end }}
{{- end }}
