# Microservices Usage
## Example deployment under microservices:
```
  backend:
    labels:
      protect: keycloak
    annotations:
      argocd.argoproj.io/hook: PreSync
      argocd.argoproj.io/hook-delete-policy: HookSucceeded
    namespace: testapp
    resources:
      limits:
        cpu: 400m
        memory: 3Gi
      requests:
        cpu: 400m
        memory: 3Gi
    image:
      repository: registry.gamewarden.io/gw/keycloak
      tag: "nightly"
    service:
      enabled: true
      type: ClusterIP
      port: 80
      name: http
      targetPort: 8080
      appProtocol: http
      additionalPorts:
      - port: 5005
        targetPort: 5005
        protocol: TCP
        name: backend
    match:
      - uri:
          prefix: /api
   # specify host and number for non-msvc host and different port number than service port
          host: nonmsvchost
          number: 8080
      - uri:
          prefix: /frontend
      - uri:
          prefix: /root
    envFrom:
      - secretRef:
          name: example
    ## - Pass in a map of env variables to add to microservice
    envs:
      ENV_VAR_1: "value1"
      ENV_VAR_2: "value2"
    ## - Pass in a list of objects for variables to add
        ## (lists are not merged when using multiple helm values files, so envs is recommended)
    extraEnvs:
    - name: _JAVA_OPTIONS
      value: -Xmx2048m -Xms512m -Dlogging.level.org.springframework=TRACE
    - name: SPRING_DATASOURCE_USERNAME
      value: DBAdmin
    - name: SPRING_DATASOURCE_PASSWORD
      valueFrom:
        secretKeyRef:
          name: example
          key: APP_DB_PASS
    - name: JAVA_TOOL_OPTIONS
      value: -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005
    serviceAccount:
      create: enabled
    rbac:
      rules:
      - apiGroups: ["apps"]
        resources: ["deployments"]
        verbs: ["get", "list", "watch", "update"]
    ## - Supported creation of maps per microservice for multiple config files
    config:
      configMapNameHere:
        .env: |
          support: stringedValuesLikeThis
          secretswithinconfigmap: sosecretshere
          service-url: http://localghost:9005
      car-json-data:
        test: testString
        support: keyValuePairsLikeThis
```
## Example statefulset under microservices:
```
  engine:
    statefulset:
      enabled: true
    resources:
      limits:
        cpu: 400m
        memory: 3Gi
      requests:
        cpu: 400m
        memory: 3Gi
    image:
      repository: registry.gamewarden.io/agencies/example
      tag: "0.0.0"
    service:
      enabled: true
      type: ClusterIP
      port: 5015
      name: http
      targetPort: 5015
      appProtocol: http
    volumeClaimTemplates:
    - metadata:
        name: www
      spec:
        accessModes: [ "ReadWriteOnce" ]
        storageClassName: "my-storage-class"
        resources:
          requests:
            storage: 1Gi
    ## - adding single simple secret for each microservice in-line
    secrets:
      stringData:
        test: test
```

## Example Secrets input per microservice:
```
microservices:
  test-app:
    secrets:
      generatekeys:
        - DB_PASSWORD
        - JOB_SECRET
## Example output:
# stringData:
#   # loop through keys and generate values if any don't exist
#   # set $mSecret to existing secret data or generate a random one when not exists
#   DB_PASSWORD: peqtK5haL5JsKJ9xgQ3AOfock6MlZXJz
#   # set $mSecret to existing secret data or generate a random one when not exists
#   JOB_SECRET: uaJOImcmf1tC5yJm0nZMSg47fz4y6YlY
#   test: "test"
```

## Use of jobs and cronjobs as microservices:
Please refer to the [configuration example for usage](docs/Example-Jobs.md) for more information.
