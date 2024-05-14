# Cluster API Charts

This project contains [Helm](https://helm.sh/) charts for [Cluster API](https://github.com/kubernetes-sigs/cluster-api) [infrastructure providers](https://cluster-api.sigs.k8s.io/reference/providers) to provision workload clusters.  These charts enable a natural continuation to utilize only `helm` instead of `clusterctl generate` to provision clusters after utilizing the helm chart from the [Cluster API operator install](https://cluster-api.sigs.k8s.io/user/quick-start-operator).  These helm charts are also convenient when paired with GitOps for provisioning numerous clusters.

## Installing CAPI Charts

### [azure-aks-aso](./charts/azure-aks-aso)

To install an AKS cluster for CAPZ using the ASO API, use the following commands:

```shell
clusterctl init --infrastructure azure
helm repo add capi https://mboersma.github.io/cluster-api-charts
helm install <name> capi/azure-aks-aso -f <my_values.yaml>
```

### [azure-managed-cluster](./charts/azure-managed-cluster)

To install an AKS cluster for CAPZ as a ManagedCluster, use the following commands:

```shell
clusterctl init --infrastructure azure
helm repo add capi https://mboersma.github.io/cluster-api-charts
helm install <name> capi/azure-managed-cluster -f <my_values.yaml>
```

## Community, discussion, contribution, and support

NOTE: This is not an official Kubernetes [sig-cluster-lifecycle](https://github.com/kubernetes/community/blob/master/sig-cluster-lifecycle/README.md) project, but it hopes to be if the community finds such a chart repository useful. This project complies with Kubernetes community standards and guidelines.

### Code of conduct

Participation in the Kubernetes community is governed by the [Kubernetes Code of Conduct](code-of-conduct.md).

[owners]: https://git.k8s.io/community/contributors/guide/owners.md
[Creative Commons 4.0]: https://git.k8s.io/website/LICENSE
