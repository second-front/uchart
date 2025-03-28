# Appinator example
```
    - customer: second-front
      destination: in-cluster
      mainChartRevision: 1.0.39
      mainChart: registry.gamewarden.io/charts  # this format is the OCI chart repo without protocol prefix
      mainChartName: uchart
      name: example-app-dev
      repoUrl: https://code.gamewarden.io/example/manifests.git  # this is where the helm values are pulled from
      targetNamespace: "argocd"
      targetRevision: main
```

# Values example
```
global:
  applicationName: "exampleApp"
  customerName: second-front
  impactLevel: il2
  environment: dev
  destinationCluster: multi-tenant-development-cluster
argocd:
  projectOverride: second-front-dev-example-app-dev # project created by Appinator
domain: gamewarden.io
```