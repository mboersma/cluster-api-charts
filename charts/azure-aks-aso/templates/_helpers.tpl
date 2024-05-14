{{- define "capz.commonLabels" -}}
app.kubernetes.io/name: azure-aks-aso
helm.sh/chart: {{ $.Chart.Name }}-{{ $.Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{- define "capz.clusterName" -}}
{{ default $.Release.Name $.Values.clusterName }}
{{- end }}

{{- define "capz.azureResourceAnnotations" -}}
serviceoperator.azure.com/credential-from: {{ $.Values.credentialSecretName }}
{{- end }}

{{- define "capz.azureASOManagedClusterSpec" -}}
{{- $ := index . 0 -}}
{{- $clusterName := index . 1 -}}
resources:
- apiVersion: resources.azure.com/v1api20200601
  kind: ResourceGroup
  metadata:
    name: {{ quote $clusterName }}
    annotations:
      {{- include "capz.azureResourceAnnotations" $ | nindent 6 }}
  spec:
    location: {{ $.Values.location }}
{{- end }}

{{- define "capz.azureASOManagedControlPlaneSpec" -}}
{{- $ := index . 0 -}}
{{- $clusterName := index . 1 -}}
version: {{ $.Values.kubernetesVersion | quote  }}
resources:
- apiVersion: "containerservice.azure.com/{{ $.Values.managedClusterAPIVersion }}"
  kind: ManagedCluster
  metadata:
    name: {{ $clusterName | quote }}
    annotations:
      {{- include "capz.azureResourceAnnotations" $ | nindent 6 }}
  spec:
    owner:
      name: {{ quote $clusterName }}
    dnsPrefix: {{ quote $clusterName }}
    location: {{ default $.Values.location $.Values.managedClusterSpec.location | quote }}
    {{- toYaml (unset $.Values.managedClusterSpec "location") | nindent 4 }}
{{- end }}

{{- define "capz.azureASOManagedMachinePoolSpec" -}}
{{- $ := index . 0 -}}
{{- $clusterName := index . 1 -}}
{{- $mpName := index . 2 -}}
{{- $mp := index . 3 -}}
resources:
- apiVersion: "containerservice.azure.com/{{ $.Values.managedMachinePoolAPIVersion }}"
  kind: ManagedClustersAgentPool
  metadata:
    name: {{ printf "%s-%s" $clusterName $mpName | quote }}
    annotations:
      {{- include "capz.azureResourceAnnotations" $ | nindent 6 }}
  spec:
    azureName: {{ $mpName | quote }}
    {{- if $mp.owner }}
      {{- fail (printf ".Values.managedMachinePoolSpecs.%s.owner is not allowed to be set." $mpName) }}
    {{- end }}
    owner:
      name: {{ quote $clusterName }}
    {{- toYaml (unset $mp "count") | nindent 4 }}
{{- end }}
