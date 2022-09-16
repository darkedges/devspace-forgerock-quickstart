# frig

[forgerock-identity-gateway](https://github.com/darkedges/devspace-forgerock-quickstart) ForgeRock Identity Gateway Helm Chart for Kubernetes.

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

## Prerequisites

- Chart version 1.x.x and above: Kubernetes v1.19+
- For Local Development / Deployment a FRIG image is required

    ```console
    git clone https://github.com/darkedges/devspace-forgerock-quickstart
    cd devspace-forgerock-quickstart/docker/frig
    docker build -t devspace-forgerock-quickstart/ig:7.2.0 .
    ```

## Install Chart

**Important:** only helm3 is supported

```console
git clone https://github.com/darkedges/devspace-forgerock-quickstart
cd devspace-forgerock-quickstart
helm install --namespace=devspace-forgerock-quickstart --create-namespace -f values/environments/localdev/frig.yaml localdev-frig helm/frig
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade Chart

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

```console
cd devspace-forgerock-quickstart
helm upgrade -f values/environments/localdev/frig.yaml localdev-frig helm/frig
```

## Uninstall Chart

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

```console
cd devspace-forgerock-quickstart
helm uninstall localdev-frig
```

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run these configuration commands:

```console
helm show values helm/frig
```

## Source Code

* <https://github.com/darkedges/devspace-forgerock-quickstart/helm/frig>

## Requirements

Kubernetes: `>=1.20.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonLabels | object | `{}` |  |
| frig.affinity | object | `{}` |  |
| frig.autoscaling.behavior | object | `{}` |  |
| frig.autoscaling.enabled | bool | `false` |  |
| frig.autoscaling.maxReplicas | int | `11` |  |
| frig.autoscaling.minReplicas | int | `1` |  |
| frig.autoscaling.targetCPUUtilizationPercentage | int | `50` |  |
| frig.autoscaling.targetMemoryUtilizationPercentage | int | `50` |  |
| frig.autoscalingTemplate | list | `[]` |  |
| frig.certificate.enabled | bool | `false` | Wether to attach a certificate to ingress |
| frig.containerSecurityContext | object | `{}` | Security Context policies for controller main container. See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls # |
| frig.dnsConfig | object | `{}` | Optionally customize the pod dnsConfig. |
| frig.dnsPolicy | string | `"ClusterFirst"` | Optionally change this to ClusterFirstWithHostNet in case you have 'hostNetwork: true'. By default, while using host network, name resolution uses the host's DNS. If you wish nginx-controller to keep resolving names inside the k8s network, use ClusterFirstWithHostNet. |
| frig.env | object | `{"IG_RUN_MODE":"development"}` | this is added by default and can be overwritten to set Environment Variables |
| frig.existingPsp | string | `""` | Use an existing PSP instead of creating one |
| frig.hostNetwork | bool | `false` | Required for use with CNI based kubernetes installations (such as ones set up by kubeadm), since CNI and hostport don't mix yet. Can be deprecated once https://github.com/kubernetes/kubernetes/issues/23920 is merged |
| frig.hostname | object | `{}` | Optionally customize the pod hostname. |
| frig.image.allowPrivilegeEscalation | bool | `true` |  |
| frig.image.chroot | bool | `false` |  |
| frig.image.imagePullPolicy | string | `"IfNotPresent"` |  |
| frig.image.repository | string | `"devspace-forgerock-quickstart/ig"` |  |
| frig.image.runAsUser | int | `11111` |  |
| frig.image.tag | string | `"7.2.0"` |  |
| frig.ingress.backend.port | int | `8080` | port being used by the backend application |
| frig.ingress.backend.protocol | string | `"HTTP"` | scheme being used by the backend application |
| frig.ingress.enabled | bool | `false` | Wether to expose the service to ingress |
| frig.ingress.hosts | list | `[]` | List of hostname to use for ingress |
| frig.keda.apiVersion | string | `"keda.sh/v1alpha1"` |  |
| frig.keda.behavior | object | `{}` |  |
| frig.keda.cooldownPeriod | int | `300` |  |
| frig.keda.enabled | bool | `false` |  |
| frig.keda.maxReplicas | int | `11` |  |
| frig.keda.minReplicas | int | `1` |  |
| frig.keda.pollingInterval | int | `30` |  |
| frig.keda.restoreToOriginalReplicaCount | bool | `false` |  |
| frig.keda.scaledObject.annotations | object | `{}` |  |
| frig.keda.triggers | list | `[]` |  |
| frig.keystore.password | string | `"changeit"` | Password for the keystore |
| frig.labels | object | `{}` | Labels to be added to the controller Deployment or DaemonSet and other resources that do not have option to specify labels # |
| frig.lifecycle | object | `{"preStop":{"exec":{"command":["/opt/frig/docker-entrypoint.sh stop"]}}}` | Improve connection draining when ingress controller pod is deleted using a lifecycle hook: With this new hook, we increased the default terminationGracePeriodSeconds from 30 seconds to 300, allowing the draining of connections up to five minutes. If the active connections end before that, the pod will terminate gracefully at that time. To effectively take advantage of this feature, the Configmap feature worker-shutdown-timeout new value is 240s instead of 10s. # |
| frig.livenessProbe.failureThreshold | int | `5` |  |
| frig.livenessProbe.httpGet.path | string | `"/openig/ping"` |  |
| frig.livenessProbe.httpGet.port | int | `8443` |  |
| frig.livenessProbe.httpGet.scheme | string | `"HTTPS"` |  |
| frig.livenessProbe.initialDelaySeconds | int | `10` |  |
| frig.livenessProbe.periodSeconds | int | `10` |  |
| frig.livenessProbe.successThreshold | int | `1` |  |
| frig.livenessProbe.timeoutSeconds | int | `1` |  |
| frig.minAvailable | int | `1` |  |
| frig.minReadySeconds | int | `0` | `minReadySeconds` to avoid killing pods before we are ready # |
| frig.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | Node labels for controller pod assignment # Ref: https://kubernetes.io/docs/user-guide/node-selection/ # |
| frig.podSecurityContext | object | `{}` | Security Context policies for controller pods See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls # |
| frig.readinessProbe.failureThreshold | int | `3` |  |
| frig.readinessProbe.httpGet.path | string | `"/openig/ping"` |  |
| frig.readinessProbe.httpGet.port | int | `8443` |  |
| frig.readinessProbe.httpGet.scheme | string | `"HTTPS"` |  |
| frig.readinessProbe.initialDelaySeconds | int | `10` |  |
| frig.readinessProbe.periodSeconds | int | `10` |  |
| frig.readinessProbe.successThreshold | int | `1` |  |
| frig.readinessProbe.timeoutSeconds | int | `1` |  |
| frig.replicaCount | int | `1` | number of replicas |
| frig.resources.requests.cpu | string | `"100m"` |  |
| frig.resources.requests.memory | string | `"90Mi"` |  |
| frig.sysctls | object | `{}` | See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls |
| frig.tolerations | list | `[]` | Node tolerations for server scheduling to nodes with taints # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ # |
| frig.topologySpreadConstraints | list | `[]` | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # |
| frig.updateStrategy | object | `{}` | The update strategy to apply to the Deployment or DaemonSet # |
| imagePullSecrets | list | `[]` | Optional array of imagePullSecrets containing private registry credentials # Ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| podSecurityPolicy.enabled | bool | `false` |  |
| rbac.create | bool | `true` |  |
| rbac.scope | bool | `false` |  |
| revisionHistoryLimit | int | `10` | Rollback limit # |
| serviceAccount.annotations | object | `{}` | Annotations for the controller service account |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

