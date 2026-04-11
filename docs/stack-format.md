# Stack Descriptor Format

## Overview

Stack descriptors define platform application stacks that can be deployed onto Kubernetes clusters. Each descriptor is a YAML file that specifies the stack's metadata, components, default resource allocations, and user-overridable values.

## Schema

Each `stack.yaml` file contains the following top-level fields:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `slug` | string | yes | Unique identifier (lowercase, hyphenated) |
| `display_name` | string | yes | Human-readable name for the dashboard |
| `description` | string | yes | Brief description of the stack's purpose |
| `component_name` | string | yes | OCI artifact reference for the Helm chart / OCM component |
| `default_version` | string | yes | Semver version deployed when none is specified |
| `components` | list | yes | Software components included in the stack |
| `namespace` | string | yes | Kubernetes namespace for deployment |
| `category` | string | yes | Dashboard grouping category |
| `icon` | string | yes | Icon identifier for the UI |
| `docs_url` | string | yes | Link to stack documentation |
| `defaults` | map | yes | Default resource allocations and feature flags |
| `overridable_values` | list | yes | Parameters users can customize from the dashboard |

### defaults

A map defining component-specific default resource requests/limits, replica counts, and feature flags.

### overridable_values

A list of tunable parameters. Each entry has:

| Field | Type | Description |
|-------|------|-------------|
| `key` | string | Dot-notation path to the value (e.g., `service.replicas`) |
| `type` | string | `integer` or `string` |
| `description` | string | Human-readable description |
| `min` / `max` | integer | For integer types: allowed range |
| `allowed_values` | list | For string types: enumerated allowed values |

## Available Stacks

| Stack | Category | Description |
|-------|----------|-------------|
| observability | operations | Prometheus + Grafana + Loki monitoring stack |
| bi-analytics | data | Business intelligence and analytics (Airflow + Superset) |
| ci-runners | developer-platform | CI/CD runner infrastructure (GitHub Actions, GitLab) |
| kubeflow | ai-ml | Machine learning platform (Kubeflow + Istio + Knative) |
| kubewp | applications | WordPress hosting runtime (KubeWP) |
| kubesage | intelligence | KubeSage AI monitoring and cost optimization agent |

## Creating Custom Stacks

To create a custom stack:

1. Copy the example template: `cp examples/custom-stack.yaml stacks/my-stack/stack.yaml`
2. Edit the descriptor with your stack's metadata, components, and defaults
3. Validate with yamllint: `yamllint stacks/my-stack/stack.yaml`
4. Add a `README.md` in the stack directory describing the stack's purpose and components
5. Submit a pull request

See [`../examples/custom-stack.yaml`](../examples/custom-stack.yaml) for a fully commented template.
