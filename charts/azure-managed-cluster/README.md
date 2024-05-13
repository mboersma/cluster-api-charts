# Cluster API Provider Azure Managed Cluster Helm Chart

This Helm chart is used to deploy a CAPZ Managed Cluster to a Cluster API Management Cluster.

## 1. Prerequisites

Create a Kubernetes cluster with a resource like kind and install the Cluster API Provider Azure (CAPZ) components with

```bash
clusterctl init --infrastructure azure
```

## 2. Add the repo for the CAPZ Managed Cluster Helm Chart

```bash
helm repo add capi https://mboersma.github.io/cluster-api-charts
```

## 3. Specify values for the CAPZ Managed Cluster Helm Chart

Create a `values.yaml` to specify credentials and other values for the CAPZ Managed Cluster Helm Chart. It can look like the following:

```yaml
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

## 4. Install the CAPZ Managed Cluster Helm Chart

```bash
helm install <name> capi/azure-managed-cluster -f values.yaml
```

## 5. Uninstall the CAPZ Managed Cluster Helm Chart

```bash
helm uninstall <name>
```

**Note:** Uninstall currently is bugged as it fails with `Error: failed to delete release`.

**Note:** the AzureClusterIdentity and cluster identity secret are not deleted when the chart is uninstalled since deleting them would remove the credentials needed to delete the Azure resources.
