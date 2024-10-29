{{- define "uchart.image" -}}
  {{- $image := "" -}}
  {{- $msvc := index . "msvc" -}}
  {{- with .image -}}
    {{- if .name }}
      {{- if $.Values.global.image.defaultImageRegistry }}
        {{- if $.Values.global.image.defaultImageRepository }}
          {{- $image = printf "%s/%s/%s:%s" $.Values.global.image.defaultImageRegistry $.Values.global.image.defaultImageRepository .name .tag }}
        {{- else }}
          {{- $image = printf "%s/%s:%s" $.Values.global.image.defaultImageRegistry .name .tag }}
        {{- end }}
      {{- end }}
    {{- else }}
      {{- if $.Values.global.image.defaultImageRegistry }}
        {{- if $.Values.global.image.defaultImageRepository }}
          {{- $image = printf "%s/%s/%s:%s" $.Values.global.image.defaultImageRegistry $.Values.global.image.defaultImageRepository $msvc .tag }}
        {{- else }}
          {{- $image = printf "%s/%s:%s" $.Values.global.image.defaultImageRegistry $msvc .tag }}
        {{- end }}
      {{- end }}
    {{- end }}
    {{- if .repository }}
      {{- $image = printf "%s:%s" .repository .tag }}
    {{- end }}
  {{- end }}
  {{- printf "%s" $image -}}
{{- end }}
