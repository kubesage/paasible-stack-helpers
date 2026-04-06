# Stack Descriptor Format

## Overview

Stack descriptors define platform application stacks that can be deployed onto Gardener-managed Kubernetes clusters via PaaSible. Each descriptor is a YAML file that specifies the stack's metadata, components, tier-specific resource presets, and user-overridable values.

PaaSible reads these descriptors to populate its stack catalog and enforce resource boundaries per pricing tier.

## Schema

Each `stack.yaml` file contains the following top-level fields:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `slug` | string | yes | Unique identifier (lowercase, hyphenated) |
| `display_name` | string | yes | Human-readable name for the dashboard |
| `description` | string | yes | Brief description of the stack's purpose |
| `component_name` | string | yes | OCI artifact reference for the Helm chart / OCM component |
| `default_version` | string | yes | Semver version deployed when none is specified |
| `compatible_tiers` | list | yes | PaaSible pricing tiers that can use this stack (`free`, `starter`, `pro`, `enterprise`) |
| `components` | list | yes | Software components included in the stack |
| `namespace` | string | yes | Kubernetes namespace for deployment |
| `category` | string | yes | Dashboard grouping category |
| `icon` | string | yes | Icon identifier for the UI |
| `docs_url` | string | yes | Link to stack documentation |
| `tier_presets` | map | yes | Per-tier resource allocations and feature flags |
| `overridable_values` | list | yes | Parameters users can customize from the dashboard |

### tier_presets

A map keyed by tier name (`free`, `starter`, `pro`, `enterprise`). Each tier entry defines component-specific resource requests/limits, replica counts, and feature flags. Only tiers listed in `compatible_tiers` need entries here.

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

| Stack | Category | Tiers | Description |
|-------|----------|-------|-------------|
| observability | operations | free, starter, pro, enterprise | VictoriaMetrics + Grafana monitoring stack |
| bi-analytics | data | pro, enterprise | Business intelligence and analytics tools (Airflow + Superset) |
| ci-runners | developer-platform | starter, pro, enterprise | CI/CD runner infrastructure (GitHub Actions, GitLab) |
| kubeflow | ai-ml | pro, enterprise | Machine learning platform (Kubeflow + Istio + Knative) |
| kubewp | applications | enterprise | WordPress hosting runtime (KubeWP) |
| kubesage | intelligence | pro, enterprise | KubeSage AI monitoring and cost optimization agent |

## Creating Custom Stacks

To create a custom stack:

1. Copy the example template: `cp examples/custom-stack.yaml stacks/my-stack/stack.yaml`
2. Edit the descriptor with your stack's metadata, components, and tier presets
3. Validate with yamllint: `yamllint stacks/my-stack/stack.yaml`
4. Add a `README.md` in the stack directory describing the stack's purpose and components
5. Submit a pull request

See [`../examples/custom-stack.yaml`](../examples/custom-stack.yaml) for a fully commented template.

## Integration with PaaSible

PaaSible reads these stack descriptors to offer one-click stack deployment in the dashboard. When a user selects a stack:

1. PaaSible checks the cluster's pricing tier against `compatible_tiers`
2. The appropriate `tier_presets` entry is selected as the base configuration
3. Any user-customized `overridable_values` are merged on top
4. The stack is deployed to the target cluster's namespace via Flux and the OCM controller
5. The `component_name` OCI reference is used to pull the packaged Helm chart

Stack descriptors are the single source of truth for what stacks are available and how they are configured per tier.
