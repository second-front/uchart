# Using SubCharts with uchart 2.0

Starting with version 2.0.0, uchart uses standard Helm chart dependencies instead of ArgoCD Applications for managing subcharts.

## Overview

SubCharts allow you to include other Helm charts as dependencies of your main application chart. Common use cases include:
- Database charts (PostgreSQL, MySQL, Redis)
- Message queues (RabbitMQ, Kafka)
- Caching layers (Memcached, Redis)
- Monitoring tools

## How It Works

1. **Define dependencies in Chart.yaml** - Declare which charts you want to include
2. **Download dependencies** - Run `helm dependency update` to fetch the charts
3. **Configure via values.yaml** - Pass configuration to each subchart using the `subCharts` section
4. **Deploy together** - All charts deploy as a single unit with your application

## Step-by-Step Guide

### Step 1: Add Dependencies to Chart.yaml

Edit `Chart.yaml` and add a `dependencies` section:

```yaml
dependencies:
  - name: redis
    version: "17.9.5"
    repository: "https://charts.bitnami.com/bitnami"
    condition: subCharts.redis.enabled
  - name: postgresql
    version: "12.0.0"
    repository: "https://charts.bitnami.com/bitnami"
    condition: subCharts.postgresql.enabled
```

**Key fields:**
- `name`: The chart name (must match the `subCharts.<name>` key in values.yaml)
- `version`: Specific chart version to use
- `repository`: Chart repository URL
- `condition`: Value path that enables/disables this chart (recommended)

### Step 2: Download Dependencies

Run this command to download the dependency charts:

```bash
helm dependency update
```

This creates a `charts/` directory containing the dependency charts.

### Step 3: Configure SubCharts in values.yaml

Add configuration for each subchart:

```yaml
subCharts:
  redis:
    enabled: true
    architecture: standalone
    auth:
      enabled: true
      password: "myredispassword"
    master:
      resources:
        requests:
          cpu: 100m
          memory: 128Mi

  postgresql:
    enabled: true
    auth:
      username: myapp
      password: "mydbpassword"
      database: myappdb
```

**Important notes:**
- The key name (e.g., `redis`) must match the dependency `name` in Chart.yaml
- The `enabled` field controls whether this chart is deployed (via the `condition` in Chart.yaml)
- All other values are passed directly to the dependency chart

### Step 4: Connect Your App to SubCharts

Reference the subchart services in your microservices:

```yaml
microservices:
  backend:
    image:
      repository: myregistry/backend
      tag: "1.0.0"
    extraEnvs:
      - name: REDIS_HOST
        value: "myapp-redis-master"  # Service name format: <release>-<chart>-<service>
      - name: REDIS_PORT
        value: "6379"
      - name: DB_HOST
        value: "myapp-postgresql"
      - name: DB_PORT
        value: "5432"
```

**Service naming convention:**
- Format: `<release-name>-<chart-name>[-<service-type>]`
- Example: If your release is `myapp` and you're using redis, the master service is `myapp-redis-master`

### Step 5: Deploy

```bash
helm install myapp . -f values.yaml
```

Or if updating:

```bash
helm upgrade myapp . -f values.yaml
```

## SubCharts Reference Library

The file `subCharts-values.yaml` in the chart root contains **ready-to-use configurations** for common infrastructure charts:

- PostgreSQL, MySQL - Databases
- Redis - Cache
- RabbitMQ, NATS - Message queues
- Vault - Secret management
- PgAdmin - Database admin UI
- Strimzi Kafka Operator - Kafka on Kubernetes
- MinIO - Object storage

Simply copy the section you need into your `values.yaml` file and customize as needed. Each section includes:
- Chart.yaml dependency snippet
- Recommended configuration
- Resource limits
- Links to official documentation

## Finding Available Charts

### Popular Chart Repositories

**Bitnami (recommended):**
```
https://charts.bitnami.com/bitnami
```

Common charts: redis, postgresql, mysql, mongodb, rabbitmq, kafka, nginx, etc.

**Artifact Hub:**
Visit https://artifacthub.io/ to browse thousands of Helm charts.

### Finding Chart Configuration Options

To see what values you can configure for a chart:

```bash
# Add the repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Show available values
helm show values bitnami/redis

# Or view documentation
helm show readme bitnami/redis
```

## Examples

### Example 1: Redis Only

**Chart.yaml:**
```yaml
dependencies:
  - name: redis
    version: "17.9.5"
    repository: "https://charts.bitnami.com/bitnami"
    condition: subCharts.redis.enabled
```

**values.yaml:**
```yaml
subCharts:
  redis:
    enabled: true
    architecture: standalone
    auth:
      enabled: false  # Disable authentication for development
```

### Example 2: PostgreSQL with Generated Secrets

**Chart.yaml:**
```yaml
dependencies:
  - name: postgresql
    version: "12.0.0"
    repository: "https://charts.bitnami.com/bitnami"
    condition: subCharts.postgresql.enabled
```

**values.yaml:**
```yaml
generatedSecrets:
  enabled: true

subCharts:
  postgresql:
    enabled: true
    auth:
      username: myapp
      database: myappdb
      existingSecret: generated-secrets
      secretKeys:
        adminPasswordKey: GENERATED_DB_PASSWORD
        userPasswordKey: GENERATED_DB_PASSWORD
```

### Example 3: Multiple Dependencies

**Chart.yaml:**
```yaml
dependencies:
  - name: redis
    version: "17.9.5"
    repository: "https://charts.bitnami.com/bitnami"
    condition: subCharts.redis.enabled
  - name: postgresql
    version: "12.0.0"
    repository: "https://charts.bitnami.com/bitnami"
    condition: subCharts.postgresql.enabled
  - name: rabbitmq
    version: "11.0.0"
    repository: "https://charts.bitnami.com/bitnami"
    condition: subCharts.rabbitmq.enabled
```

**values.yaml:**
```yaml
subCharts:
  redis:
    enabled: true
    # ... redis config

  postgresql:
    enabled: true
    # ... postgresql config

  rabbitmq:
    enabled: false  # Disabled for this environment
    # ... rabbitmq config
```

## Troubleshooting

### Dependency not found
```
Error: found in Chart.yaml, but missing in charts/ directory
```
**Solution:** Run `helm dependency update`

### Wrong service name
```
Error: unable to connect to redis
```
**Solution:** Check the service name format. Use `kubectl get svc` to see actual service names.

### Values not applying
```
Chart deployed but subchart using default values
```
**Solution:** Ensure the key in `subCharts:` exactly matches the chart `name` in Chart.yaml dependencies.

### Version conflicts
```
Error: chart requires kubeVersion
```
**Solution:** Check chart compatibility or use a different version of the dependency chart.

## Migration from uchart 1.x

If you're migrating from uchart 1.x (which used ArgoCD Applications for subcharts):

**Old approach (1.x with ArgoCD):**
```yaml
subCharts:
  redis:
    chartUrl: registry.gamewarden.io/charts
    chart: redis
    revision: 17.9.5
    values:
      auth:
        password: "mypassword"
```

**New approach (2.0 with Helm dependencies):**

1. Add to Chart.yaml:
```yaml
dependencies:
  - name: redis
    version: "17.9.5"
    repository: "https://charts.bitnami.com/bitnami"
    condition: subCharts.redis.enabled
```

2. Update values.yaml:
```yaml
subCharts:
  redis:
    enabled: true
    auth:
      password: "mypassword"
```

3. Run:
```bash
helm dependency update
```

## Using SubCharts Without Microservices

You can deploy **only infrastructure** without any custom application microservices:

```yaml
global:
  applicationName: myinfra
  customerName: mycompany
  impactLevel: il2
  environment: dev

# Leave microservices empty
microservices: {}

# Configure only dependencies
subCharts:
  redis:
    enabled: true
    # ... redis config
  postgresql:
    enabled: true
    # ... postgresql config
```

This is useful for:
- Setting up shared infrastructure across multiple applications
- Creating development environments with backing services only
- Pre-provisioning databases/caches before application deployment

See [subcharts-only-example.yaml](test-values/subcharts-only-example.yaml) for a complete example.

## Best Practices

1. **Pin versions**: Always specify exact chart versions in Chart.yaml
2. **Use conditions**: Add `condition: subCharts.<name>.enabled` to allow toggling charts
3. **Resource limits**: Set appropriate resource requests/limits for subcharts
4. **Secrets management**: Use `generatedSecrets` or external secret management
5. **Test separately**: Test dependency charts work correctly before integrating
6. **Document service names**: Document the service names for your team to reference

## Additional Resources

- [Helm Dependencies Documentation](https://helm.sh/docs/helm/helm_dependency/)
- [Artifact Hub](https://artifacthub.io/)
- [Bitnami Charts](https://github.com/bitnami/charts)
- [uchart Examples](../test-values/)
