# Cluster API Charts

This project contains [Helm](https://helm.sh/) charts for [Cluster API](https://github.com/kubernetes-sigs/cluster-api) [infrastructure providers](https://cluster-api.sigs.k8s.io/reference/providers) to provision workload clusters.  These charts enable a natural continuation to utilize only `helm` instead of `clusterctl generate` to provision clusters after utilizing the helm chart from the [Cluster API operator install](https://cluster-api.sigs.k8s.io/user/quick-start-operator).  These helm charts are also convenient when paired with GitOps for provisioning numerous clusters.

## Installing CAPI Charts

This is the foundational step for any cloud provider to install CAPI and then use any charts from this repository:

```shell
helm repo add capi-operator https://kubernetes-sigs.github.io/cluster-api-operator
helm repo add capi https://mboersma.github.io/cluster-api-charts
helm repo add jetstack https://charts.jetstack.io --force-update
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true
```

### Azure

Use this command to install CAPI with the Azure provider (CAPZ) and all feature flags for any of the Azure charts below.

```shell
helm install capi-operator capi-operator/cluster-api-operator --create-namespace -n capi-operator-system \
--set infrastructure="azure" \
--set manager.featureGates.core.MachinePool="true" \
--set manager.featureGates.azure.MachinePool="true" \
--set manager.featureGates.azure.ASOAPI="true" \
--set manager.featureGates.azure.ClusterResourceSet="true" \
--set manager.featureGates.azure.ClusterTopology="true" \
--set manager.cert-manager.enabled="false" \
--set manager.cert-manager.installCRDs="false"
```

#### [azure-aks-aso](./charts/azure-aks-aso)

To install an AKS cluster for [CAPZ using the new experimental ASO API](https://capz.sigs.k8s.io/topics/aso.html?highlight=azure%20service%20ope#experimental-aso-api), use the following commands:

```
helm install capaksaso capi/azure-aks-aso -f <my_values.yaml>
```

#### [azure-managed-cluster](./charts/azure-managed-cluster)

To install an AKS cluster for CAPZ with [existing v1 ManagedCluster API](https://capz.sigs.k8s.io/topics/managedcluster), use the following commands:

```shell
helm install azure-managed-cluster capi/azure-managed-cluster -f <my_values.yaml>
```

## Community, discussion, contribution, and support

NOTE: This is not an official Kubernetes [sig-cluster-lifecycle](https://github.com/kubernetes/community/blob/master/sig-cluster-lifecycle/README.md) project, but it hopes to be if the community finds such a chart repository useful. This project complies with Kubernetes community standards and guidelines.

### Code of conduct

Participation in the Kubernetes community is governed by the [Kubernetes Code of Conduct](code-of-conduct.md).

[owners]: https://git.k8s.io/community/contributors/guide/owners.md
[Creative Commons 4.0]: https://git.k8s.io/website/LICENSE
