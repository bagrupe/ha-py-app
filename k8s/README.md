# K8s

This directory contains a Helm chart for deploying the various parts of the KommunalApp to Kubernetes. This is intended
to be used for QA-Deployments / Review Apps but may serve other purposes in the future.

The directory also contains a `./one-time-setup.yaml` to create a baseline configuration supporting the deployments.

## Directory structure

The deployment files are split into fairly generic helm templates in `templates/_bases`, component definitions in
`components/` as well as a `full-deployment.yaml` which generates the full deployment.

## Components

A component consists of the following structure:

```ts
type SinglePort = number | { number: number; name?: string; }
type MultiplePorts = { number: number; name: string; }[]
type PortSpec = { port: SinglePort; } | { ports: MultiplePorts; };

type ComponentScope = {
  name: string;
  deployment: {
    image: { tag: string; } | { example: true; name: string; };
    resources: { requests: { cpu: string; memory: string }; limits: { cpu: string; memory: string }; };
    env?: { name: string; value: string; }[];
    secrets?: string;
  } & PortSpec;
  ingress?: { hostPrefix?: string; paths: string[]; };
}
```

A component can be defined as a YAML file in the components directory and then included by its name in `values.yaml`. A
component's deployment currently consists of:

- An ingress (only if `component.ingress` is defined)
- A service forwarding all ports defined in `component.deployment` (if a port is defined by number only, it is forwarded
  to port 80 otherwise to the number defined)
- A deployment with a single container that has its defined by `component.deployment.image` (
  if `component.deployment.image.example` is true, it's templated to an image in the configured registry)
- A secret (only if `component.deployment.secrets` is defined)

## Existing components

Currently, the following components are being deployed:
- Backend - Available without host prefix
- Bereich A - Available without host prefix
- Bereich B - Available with host prefix `bereich-b-`
- Mongo - Not available through an ingress
- Postgres - Not available through an ingress
- Storybook - Available with host prefix `storybook-`
- Widgetbook - Available with host prefix `widgetbook-`
