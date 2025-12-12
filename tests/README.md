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

# Run specific test file
helm unittest uchart/ -f 'tests/subcharts_without_microservices_test.yaml'

# Run with verbose output
helm unittest uchart/ -v
```

**Note:** All test files must end with `_test.yaml` to be auto-discovered by helm-unittest.

## Test Files

### `subcharts_without_microservices_test.yaml`
Tests to verify the chart works correctly with `subCharts` defined but without `microservices`. This validates the fix for allowing infrastructure resources to be created independently.

**What it tests:**
- ✅ ArgoCD Application wrappers are created with only subCharts
- ✅ CiliumNetworkPolicy resources are created without microservices
- ✅ Kubernetes NetworkPolicy resources are created without microservices
- ✅ Istio mTLS PeerAuthentication is created without microservices
- ✅ Generated secrets are created without microservices
- ✅ Resource templates (deployment, service, etc.) are NOT created when using subCharts mode
- ✅ VirtualService is NOT created without microservices

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
helm template test-release ./uchart -f uchart/tests/test-values-subcharts-only.yaml

# Verify specific resource types are generated
helm template test-release ./uchart -f uchart/tests/test-values-subcharts-only.yaml | grep -E "^kind:" | sort | uniq -c

# Expected output:
#   3 kind: Application           (ArgoCD wrappers)
#   8 kind: CiliumNetworkPolicy   (Network policies)
```

### Test with microservices only (no subCharts)

```bash
# Use the default values.yaml which includes microservices
helm template test-release ./uchart -f uchart/values.yaml
```

## Architecture Validation

The tests validate three deployment modes:

1. **subCharts only** (no microservices)
   - ArgoCD Applications wrap external charts
   - Infrastructure resources (network policies, secrets, mTLS) are created
   - No direct resource templates (deployments, services) are created

2. **microservices only** (no subCharts)
   - Direct resource templates are created
   - Infrastructure resources are created
   - No ArgoCD Application wrappers

3. **Both subCharts and microservices**
   - ArgoCD Applications for subCharts
   - Additional microservices can supplement
   - Infrastructure resources are created

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
