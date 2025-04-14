{{- define "2f.uchart.legacy.secretGenerationJob" -}}
{{- if or (.Values.argocd.wrapperAppOff) ( not .Values.subCharts ) }}
{{- if .Values.generateSecretsJob.enabled }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: secret-generator-role
  namespace: "{{ .Release.Namespace }}"
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["create", "patch", "get", "list"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: secret-generator-binding
  namespace: "{{ .Release.Namespace }}"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: secret-generator-role
subjects:
- kind: ServiceAccount
  name: secret-generator-sa
  namespace: "{{ .Release.Namespace }}"
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: secret-generator-sa
  namespace: "{{ .Release.Namespace }}"
---
apiVersion: batch/v1
kind: Job
metadata:
  name: "{{ .Release.Name }}-generate-secrets"
  namespace: {{ .Release.Namespace }}
spec:
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "false"
    spec:
      imagePullSecrets:
        - name: private-registry
      containers:
        - name: secret-generator
          image: "{{ .Values.generateSecretsJob.image | default "registry.gamewarden.io/steelbank/2f_internal/kubernetes/kubectl-dev:1.31.2-r2" }}"
          command: ["/bin/sh", "-c"]
          args:
            - |
              # Function to generate a password
              generate_password() {
                local length=$1
                local charset=$2
                local output=$3
                if [ "$output" = "base64" ]; then
                  head /dev/urandom | tr -dc "$charset" | head -c "$length" | base64
                else
                  head /dev/urandom | tr -dc "$charset" | head -c "$length"
                fi
              }

              # Function to generate TLS certificates
              generate_tls_cert() {
                local cert_name=$1
                local namespace=$2
                local valid_days=${3:-365}
                local dns_suffix=".svc"
                local temp_dir=/tmp/cert-gen
                local workdir=$(pwd)

                cat <<EOF > ""${temp_dir}/san.conf
              [req_ext]
              subjectAltName = @san

              [san]
              DNS.1 = ${cert_name}.${namespace}${dns_suffix}
              DNS.2 = *.${cert_name}.${namespace}${dns_suffix}
              EOF

                openssl req -x509 -nodes -newkey rsa:4096 \
                  -keyout "/tmp/cert-gen/${cert_name}.key" \
                  -out "/tmp/cert-gen/${cert_name}.crt" \
                  -days "${valid_days}" \
                  -subj "/CN=${cert_name}" \
                  -reqexts req_ext -extensions req_ext \
                  -config <(cat ${temp_dir}/san.conf)
              }

              # Loop through secrets and create them
              {{- range $secretName, $secretConfig := .Values.generateSecretsJob.secrets }}
              if ! kubectl get secret "{{ $secretName }}" -n "{{ $.Release.Namespace }}" > /dev/null 2>&1; then
                echo "Creating secret '{{ $secretName }}'..."

                {{- if eq $secretConfig.type "Opaque" }}
                kubectl create secret generic "{{ $secretName }}" --namespace="{{ $.Release.Namespace }}" \
                  {{- range $key, $value := $secretConfig.stringData }}
                  {{- if eq $value "nuget" }}
                  --from-literal="{{ $key }}=$(generate_password 40 "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")" \
                  {{- else }}
                  --from-literal="{{ $key }}=$(generate_password 16 "A-Za-z0-9@#%&*")" \
                  {{- end }}
                  {{- end }}
                  -o yaml --dry-run=client | kubectl apply -f -
                kubectl patch secret "{{ $secretName }}" --namespace="{{ $.Release.Namespace }}" \
                -p '{"metadata":{"finalizers":["prevent.io/prevent-delete"]}}' --type=merge
                {{- end }}

                {{- if eq $secretConfig.type "kubernetes.io/tls" }}
                generate_tls_cert "{{ $secretName }}" "{{ $.Release.Namespace }}"
                kubectl create secret tls "{{ $secretName }}" --namespace="{{ $.Release.Namespace }}" \
                  --cert="/tmp/cert-gen/{{ $secretName }}.crt" --key="/tmp/cert-gen/{{ $secretName }}.key" \
                  -o yaml --dry-run=client | kubectl apply -f -
                kubectl patch secret "{{ $secretName }}" --namespace="{{ $.Release.Namespace }}" \
                -p '{"metadata":{"finalizers":["prevent.io/prevent-delete"]}}' --type=merge
                rm -rf "/tmp/cert-gen/*"
                {{- end }}

                {{- if eq $secretConfig.type "kubernetes.io/basic-auth" }}
                kubectl create secret generic "{{ $secretName }}" --namespace="{{ $.Release.Namespace }}" \
                  --from-literal=username="{{ $secretConfig.stringData.username | default "default-user" }}" \
                  --from-literal=password="$(generate_password 16 "A-Za-z0-9@#%&*" base64)" \
                  -o yaml --dry-run=client | kubectl apply -f -
                kubectl patch secret "{{ $secretName }}" --namespace="{{ $.Release.Namespace }}" \
                -p '{"metadata":{"finalizers":["prevent.io/prevent-delete"]}}' --type=merge
                {{- end }}
              else
                echo "Secret '{{ $secretName }}' already exists. Skipping creation."
              fi
              {{- end }}
          env:
            - name: RELEASE_NAME
              value: "{{ .Release.Name }}"
            - name: NAMESPACE
              value: "{{ .Release.Namespace }}"
          volumeMounts:
            - name: cert-gen-temp-dir
              mountPath: /tmp/cert-gen
      volumes:
        - name: cert-gen-temp-dir
          emptyDir: {}
      restartPolicy: OnFailure
      serviceAccountName: secret-generator-sa
  backoffLimit: 3
{{- end }}
{{- end }}
{{- end }}
