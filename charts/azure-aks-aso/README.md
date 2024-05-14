# azure-aks-aso Chart

This Helm chart is used to deploy an Azure Kubernetes Service (AKS) Cluster using the Azure Service Operator (ASO) API.

## Prerequisites

Create a Kubernetes cluster to serve as a Cluster API management cluster. (For example, with `kind`.) Install the Cluster API Provider Azure (CAPZ) components on it with:

```shell
clusterctl init --infrastructure azure
```

## Add the cluster-api-charts repository to Helm

```shell
helm repo add capi https://mboersma.github.io/cluster-api-charts
```

## Specify values for the CAPZ AKS-ASO chart

Create a `values.yaml` file to specify credentials and other values for the CAPZ AKS-ASO chart. It can look like the following:

```yaml
credentialSecretName: "aso-credentials"
createCredentials: true
subscriptionID: ""
tenantID: ""
clientID: ""
clientSecret: ""
authMode: ""

# clusterName defaults to the name of the Helm release
clusterName: ""
location: eastus
clusterNetwork: null
kubernetesVersion: v1.28.9
subscriptionID: <subscription-id>
identity:
  clientID: <client-id>
  tenantID: <tenant-id>
  type: WorkloadIdentity
cluster:
  location: eastus
  cidrBlocks:
  - 192.168.0.0/16
controlplane:
  sshPublicKey: <ssh-public-key>
  networkPolicy: "calico"
  networkPlugin: "kubenet"
  networkPluginMode: null
```

## Install the CAPZ AKS-ASO Helm chart

```bash
helm install <name> capi/azure-aks-aso -f values.yaml
```

## Uninstall the CAPZ AKS-ASO Helm chart

```bash
helm uninstall <name>
```
