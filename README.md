## How to use for organizations
1. Create a values.yaml in the root of a manifests project repo.
   ```touch base-values.yaml```
1. For each microservice to deploy populate the microservices block and fill in required global fields
```yaml
global:
  applicationName: testapp # required for naming application to be deployed
  customerName: testapp    # required for labeling organization
  impactLevel: il2         # required for labeling
  environment: dev         # required for labeling
microservices:
  <MSVC_NAME>: #   (example: frontend)
    image:
      repository: <CONTAINER_REGISTRY_PATH>
      tag: <TAG OF THE CONTAINER>
  <MSVC_NAME_2>: # (example: backend)
    ...
```
5. Configure available subcharts as needed like postgres, pgadmin, etc...
6. See ***example*** deployed app for ***usage*** [here](https://code.il2.gamewarden.io/gamewarden/tools/charts/uchart/-/blob/main/docs/test-values)

# uchart

chart version: 1.0.11

A universal application chart for gamewarden environments

**Homepage:** <https:code.il2.gamewarden.io/gamewarden/tools/uchart>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Anthony Butt | <anthony.butt@secondfront.com> |  |
| Lucas Pick | <lucas.pick@secondfront.com> |  |

## Source Code

* <https://code.il2.gamewarden.io/gamewarden/tools/uchart>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| argocd.createNamespace | bool | `false` | Create all namespaces beforehand in sourceNamespaces (the main namespace auto-creates from argocd) |
| argocd.disableProjectCreation | bool | `false` | Disable option for creation of project for applications created from subCharts if nesting |
| argocd.projectOverride | string | `""` | Project override for the argocdWrapper microservice Application |
| argocd.serverSideApply | bool | `true` | Server Side Apply on Application wrapper (not subCharts) |
| argocd.sourceNamespaces | list | `[]` | Add additional allowed namespaces to deploy to beyond the default single namespace from applicationName |
| argocd.wrapAll | bool | `false` | wrapper all-in-one where the microservices and subCharts all are placed into a single wrapped application with multiple sources |
| argocd.wrapperAppOff | bool | `false` | Turn off the argocdWrapper Application.yaml template and instead deploy microservices without being under an argocd application |
| argocd.wrapperAppWave | string | `""` | Set argocd sync wave number on just the argocdWrapper Application if used |
| argocd.wrapperSync | bool | `true` | Sync options - Turn on or off automated syncing with pruning for the argocdWrapper Application from microservice |
| ciliumNetworkPolicies.appPolicy.enabled | bool | `true` |  |
| ciliumNetworkPolicies.customPolicies | list | `[]` | To add additional policies to the app namespace |
| ciliumNetworkPolicies.enabled | bool | `false` |  |
| config | object | `{"annotations":{},"data":{},"enabled":false}` | Global application configmap - used for all microservices deployed to one namespace |
| defaults.affinity | object | `{}` | Ensure that pods are hosted on specific nodes |
| defaults.autoscaling.enabled | bool | `false` |  |
| defaults.autoscaling.maxReplicas | int | `10` |  |
| defaults.autoscaling.minReplicas | int | `1` |  |
| defaults.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| defaults.domain | string | `"gamewarden.io"` | domain for istio virtual services |
| defaults.envFrom | list | `[]` | Extra environment variables from secrets or configMaps |
| defaults.extraEnvs | object | `{}` | Extra environment variables |
| defaults.image.pullPolicy | string | `"IfNotPresent"` |  |
| defaults.image.tag | string | `""` | Required - repository tag along with either repository or name (one is required) |
| defaults.imagePullSecrets | list | `[{"name":"private-registry"}]` | Pull secrets for the image/s |
| defaults.minReadySeconds | int | `0` |  |
| defaults.nodeSelector | object | `{}` | Restrict a Pod to only be able to run on a particular Node. |
| defaults.podAnnotations | object | `{}` |  |
| defaults.podDisruptionBudget | object | `{}` | Example Pod Disruption Budget values |
| defaults.podSecurityContext | object | `{}` |  |
| defaults.replicaCount | int | `1` | Number of replicas for the microservice |
| defaults.resources.requests.cpu | string | `"100m"` |  |
| defaults.resources.requests.memory | string | `"128Mi"` |  |
| defaults.securityContext | object | `{}` |  |
| defaults.service.additionalPorts | object | `{}` | Add additional ports to expose |
| defaults.service.appProtocol | string | `"TCP"` | Set the app procotol to allow explicit selection. (http, http2, https, tcp, tls, grpc, mongo, mysql, redis) |
| defaults.service.disablePortName | bool | `false` | Set to true to remove the port name |
| defaults.service.enabled | bool | `true` | Use a service with Microservice |
| defaults.service.headless | bool | `false` | Set the service to headless |
| defaults.service.name | string | `"http"` | Set a name for the port |
| defaults.service.port | int | `80` | Set the port you want to expose the service on. |
| defaults.service.targetPort | int | `8080` | Set the default targetPort of service to 8080 ( Port the application is listening on within the container ) |
| defaults.service.type | string | `"ClusterIP"` | Set the service type (ClusterIP, NodePort, LoadBalancer, ExternalName ) |
| defaults.serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| defaults.serviceAccount.create | bool | `false` | Specifies whether a service account should be created |
| defaults.serviceAccount.labels | object | `{}` |  |
| defaults.serviceAccount.name | string | `""` | If not set and create is true, a name is generated using the fullname template |
| defaults.strategy | object | `{}` |  |
| defaults.tolerations | list | `[]` | Applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| defaults.virtualService | object | `{"enabled":false}` | istio virtual service from chart enabled |
| extraManifests | list | `[]` | Extra kubernetes objects to deploy inline - Takes in MAP or LIST @schema type: [array, object] @schema |
| fullnameOverride | string | `""` |  |
| generatedSecrets | object | `{"enabled":false}` | Used to get around ArgoCD generating new secrets with argocd ignore annotations |
| global.applicationName | string | `"testapp"` | Required |
| global.customerName | string | `"testapp"` | Required |
| global.destinationCluster | string | `"multi-tenant-development-cluster"` | Required for using ArgocdWrapper method with subCharts key |
| global.environment | string | `"dev"` | Required |
| global.gateway | string | `"istio-system/private"` |  |
| global.image.defaultImageRegistry | string | `"registry.gamewarden.io"` | Use this with <microservice-name>.image.name instead of using <microservice-name>.image.repository to reduce duplicate yaml code in values.yaml |
| global.image.defaultImageRepository | string | `"testapp"` |  |
| global.impactLevel | string | `"il2"` | Required - Used for resource tracking with labels and used for ArgoCD naming |
| global.istio | object | `{"mtls":{"enabled":true}}` | Istio settings |
| global.istio.mtls | object | `{"enabled":true}` | enforce mtls PeerAuthentication |
| imageCredentials | list | `[]` |  |
| manifests | object | `{}` | Extra kubernetes objects to deploy inline |
| microservices | object | `{}` |  |
| nameOverride | string | `""` |  |
| networkPolicies.appPolicy.enabled | bool | `true` |  |
| networkPolicies.customPolicies | list | `[]` | To add additional netpols to the app namespace |
| networkPolicies.enabled | bool | `false` |  |
| rbac.create | bool | `false` |  |
| rbac.rules | list | `[]` |  |
| secrets | object | `{"enabled":false}` | Global application secret - used for all microservices deployed to one namespace |
| subCharts | object | `{}` | ArgoCD Wrapper for deploying extra ArgoCD Applictions, one argocd application for each subchart added below |

## How to generate schema automatically
```
helm plugin install https://github.com/karuppiah7890/helm-schema-gen
helm schema-gen values.yaml > values.schema.json
or
go install github.com/dadav/helm-schema/cmd/helm-schema@latest
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1) * select(fileIndex == 2) * select(fileIndex == 3)' values.yaml docs/helm-schema/microservices.yaml docs/helm-schema/subCharts.yaml docs/test-values/job-example-values.yaml > merged-values.yaml
helm-schema -n -k additionalProperties -k required -f merged-values.yaml
rm merged-values.yaml
```

## Chart schema available also at:
```
https://schemas.gamewarden.io/schemas/helm/uchart/uchart-1.0.11.json
```

## Manually push new version of chart to registry and push tag to git
```
helm package .
helm push $(ls *.tgz) oci://registry.gamewarden.io/charts
rm $(ls *.tgz)
```

## How to update docs dynamically
```docker run --rm --volume "$(pwd):/helm-docs" -u $(id -u) jnorwood/helm-docs:latest```

## Run test values agains't chart
```shell
for i in $(ls docs/test-values); do helm template . -f docs/test-values/$i; done
for i in $(ls docs/test-values); do helm template . -f docs/test-values/$i | kubeconform -ignore-missing-schemas -strict; done
```
