# paasible-stack-helpers

OCM-compatible platform stack descriptors and Gardener utility templates for [PaaSible](https://paasible.com). Defines pre-built application stacks (observability, ML, CI, WordPress, and more) that can be deployed onto managed Kubernetes clusters.

## Overview

Each stack descriptor is a YAML file that defines:

- Stack metadata (name, description, category, icon)
- OCI component reference for the packaged Helm chart
- Compatible pricing tiers (free, starter, pro, enterprise)
- Per-tier resource presets and feature flags
- User-overridable configuration values

PaaSible reads these descriptors to populate its stack catalog and deploy stacks onto Gardener-managed shoot clusters via Flux and OCM.

## Stacks

| Stack | Category | Tiers | Key Components |
|-------|----------|-------|----------------|
| [observability](stacks/observability/) | operations | free, starter, pro, enterprise | Prometheus, Grafana, Loki, Alertmanager |
| [bi-analytics](stacks/bi-analytics/) | data | pro, enterprise | Airflow, Superset, data lake connectors |
| [ci-runners](stacks/ci-runners/) | developer-platform | starter, pro, enterprise | GitHub Actions runners, GitLab runners |
| [kubeflow](stacks/kubeflow/) | ai-ml | pro, enterprise | Kubeflow, Istio, Knative |
| [kubewp](stacks/kubewp/) | applications | enterprise | KubeWP control plane, WordPress runtime |
| [kubesage](stacks/kubesage/) | intelligence | pro, enterprise | KubeSage Agent, Metrics Collector |

## Usage

### With PaaSible

Stack descriptors are consumed directly by the PaaSible API. When a user deploys a stack from the PaaSible dashboard, the appropriate descriptor is used to configure the deployment for their cluster's pricing tier.

### As Templates

You can use these descriptors as templates for creating your own platform stacks:

1. Copy an existing stack or the example template
2. Customize the metadata, components, and tier presets
3. Package your Helm chart as an OCI artifact
4. Reference it in the `component_name` field

## Documentation

See [docs/stack-format.md](docs/stack-format.md) for the full stack descriptor schema and field reference.

## Contributing

1. Create a new directory under `stacks/` with your stack's slug name
2. Add a `stack.yaml` following the schema documented in [docs/stack-format.md](docs/stack-format.md)
3. Add a `README.md` describing the stack's purpose, components, and target users
4. Validate your YAML: `yamllint stacks/your-stack/stack.yaml`
5. Submit a pull request

See [examples/custom-stack.yaml](examples/custom-stack.yaml) for a fully commented template.

## License

Apache License 2.0. See [LICENSE](LICENSE).
