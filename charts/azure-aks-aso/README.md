# azure-aks-aso Chart

This Helm chart is used to deploy an Azure Kubernetes Service (AKS) Cluster using the Azure Service Operator (ASO) API.

## Prerequisites

Create a Kubernetes cluster to serve as a Cluster API management cluster. (For example, with `kind`.) Install the Cluster API Provider Azure (CAPZ) components on it with:

```shell
export EXP_MACHINE_POOL=true
export CLUSTER_TOPOLOGY=true
clusterctl init --infrastructure azure
```

## Add the cluster-api-charts repository to Helm

```shell
helm repo add capi https://mboersma.github.io/cluster-api-charts
```

## Specify values for the CAPZ AKS-ASO chart

Create a `values.yaml` file to specify credentials and other values for the CAPZ AKS-ASO chart. This populates the [ASO configuration values](https://azure.github.io/azure-service-operator/guide/aso-controller-settings-options/) scoped to the management cluster resource.  To set global ASO credentials, modify the global ASO secret installed with CAPZ via `kubectl edit secrets aso-controller-settings -n capz-system`.

It can look like the following:

```yaml
credentialSecretName: "aso-credentials"
createCredentials: true
subscriptionID: ""
tenantID: ""
clientID: ""
# Leave clientSecret blank if using WorkloadIdentity
clientSecret: ""
# set to podIdentity for managed identity or service principal even if NOT using pod identity
authMode: "workloadIdentity"

# clusterName defaults to the name of the Helm release
clusterName: ""
location: westus3

managedMachinePoolSpecs:
  pool0:
    count: 1
    mode: System
    vmSize: Standard_DS2_v2
    type: VirtualMachineScaleSets
  pool1:
    count: 1
    mode: User
    vmSize: Standard_DS2_v2
    type: VirtualMachineScaleSets

clusterClassName: "aksasoclass"
withClusterClass: false
withClusterTopology: false
```

## Install the CAPZ AKS-ASO Helm chart

```bash
helm install <name> capi/azure-aks-aso -f values.yaml
```

## Install the CAPZ AKS-ASO Helm chart with ClusterClass

Be sure to set both of these values to `true` in the values.yaml file.
```yaml
withClusterClass: true
withClusterTopology: true
```

```
helm install <name> capi/azure-aks-aso -f values.yaml
```

On the first install, there will be this message and it is expected since the clusterclass needs to provision first.  It will eventually reconcile successfully.

```shell
W0829 14:39:51.801605   93841 warnings.go:70] Cluster refers to ClusterClass default/aksasoclass, but this ClusterClass does not exist. Cluster topology has not been fully validated. The ClusterClass must be created to reconcile the Cluster
```

After the ClusterClass is created, it is possible to stamp out numerous instances of that Clusterclass using just ClusterTopology by changing `withClusterClass: false` and doing different helm chart installations against that same management cluster with different release names.

## Uninstall the CAPZ AKS-ASO Helm chart

```bash
helm uninstall <name>
```

> Note: there are a number of AKSASO* resources which will say have not been deleted. This is by design to ensure proper complete cleanup.  The root cluster object will be deleted and that will cascade down to delete all the resources provisioned by the helm chart.  The only thing which will remain is the credentials secret and that can be found in the namespace where the chart provisioned.