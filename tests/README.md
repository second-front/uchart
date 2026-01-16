# Helm Chart Unit Tests

This directory contains unit tests for the uchart Helm chart.

## Test Framework

Tests use [helm-unittest](https://github.com/helm-unittest/helm-unittest) plugin.

## Installation

```bash
# Install the helm-unittest plugin
helm plugin install https://github.com/helm-unittest/helm-unittest
```

## Running Tests

```bash
# Run all tests (from the parent directory of uchart/)
helm unittest uchart/

# Or with color output
helm unittest uchart/ --color

# Run with verbose output
helm unittest uchart/ -v
```

**Note:** All test files must end with `_test.yaml` to be auto-discovered by helm-unittest.

## Test Files

### `subcharts_only_test.yaml`
Tests to verify the chart works correctly with `subCharts` (Helm dependencies) defined but without `microservices`. This validates that infrastructure resources can be created independently.

**What it tests:**
- ✅ CiliumNetworkPolicy resources are created without microservices
- ✅ Kubernetes NetworkPolicy resources are created without microservices
- ✅ Istio mTLS PeerAuthentication is created without microservices
- ✅ Generated secrets are created without microservices
- ✅ Global configmaps and secrets work without microservices
- ✅ Deployment/Service/StatefulSet resources are NOT created when only subCharts are defined
- ✅ VirtualService is NOT created without microservices

**Run with:**
```bash
helm unittest uchart/ -f 'tests/subcharts_only_test.yaml'
```

### `deployment_test.yaml`
Tests for deployment resource templates.

### `statefulset_test.yaml`
Tests for statefulset resource templates.

### `issue_42_test.yaml`
Tests for specific issue #42.

## Manual Testing

### Test with subCharts only (no microservices)

```bash
# Generate manifests using the test values file
helm template test-release . -f tests/test-values-subcharts-only.yaml

# Verify specific resource types are generated
helm template test-release . -f tests/test-values-subcharts-only.yaml | grep -E "^kind:" | sort | uniq -c

# Expected output:
#   8 kind: CiliumNetworkPolicy   (Network policies for infrastructure)
#   1 kind: ConfigMap              (Global config)
#   1 kind: PeerAuthentication    (Istio mTLS)
#   1 kind: Secret                (Generated secrets)
#   0 kind: Deployment            (no microservices)
#   0 kind: Service               (no microservices)
#   0 kind: StatefulSet           (no microservices)

# Or using the docs example:
helm template test-release . -f docs/test-values/subcharts-only-example.yaml
```

### Test with microservices

```bash
# Use the default values.yaml which includes microservices
helm template test-release ./uchart -f uchart/values.yaml
```

### Test with both subCharts and microservices

```bash
# Use the combined example
helm template test-release ./uchart -f uchart/docs/test-values/example-with-subcharts.yaml
```

## Writing New Tests

Follow the helm-unittest format:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/helm-unittest/helm-unittest/main/schema/helm-testsuite.json
tests:
  - it: should describe what is being tested
    set:
      global.applicationName: test-app
      # other values
    asserts:
      - hasDocuments:
          count: 1
      - isKind:
          of: Deployment
    template: templates/deployment.yaml
```

## CI/CD Integration

These tests should be run in CI/CD pipelines before merging changes:

```yaml
# Example GitLab CI
test:
  stage: test
  script:
    - helm plugin install https://github.com/helm-unittest/helm-unittest
    - helm unittest uchart/ --color
```

## Troubleshooting

### Plugin not found
```bash
helm plugin install https://github.com/helm-unittest/helm-unittest
```

### Tests failing after template changes
1. Review the template changes
2. Update test assertions to match new behavior
3. Ensure backward compatibility where appropriate
4. Document breaking changes

## References

- [helm-unittest documentation](https://github.com/helm-unittest/helm-unittest)
- [Helm testing best practices](https://helm.sh/docs/topics/chart_tests/)
