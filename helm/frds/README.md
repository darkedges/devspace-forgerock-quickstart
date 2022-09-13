# frds

[forgerock-directory-services](https://github.com/darkedges/devspace-forgerock-quickstart) ForgeRock Directory Services Helm Chart for Kubernetes.

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

* <https://github.com/darkedges/devspace-forgerock-quickstart/helm/frds>

## Requirements

Kubernetes: `>=1.20.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonLabels | object | `{}` |  |
| frds.affinity | object | `{}` |  |
| frds.autoscaling.behavior | object | `{}` |  |
| frds.autoscaling.enabled | bool | `false` |  |
| frds.autoscaling.enabled | bool | `false` |  |
| frds.autoscaling.maxReplicas | int | `11` |  |
| frds.autoscaling.minReplicas | int | `1` |  |
| frds.autoscaling.targetCPUUtilizationPercentage | int | `50` |  |
| frds.autoscaling.targetMemoryUtilizationPercentage | int | `50` |  |
| frds.autoscalingTemplate | list | `[]` |  |
| frds.containerSecurityContext | object | `{}` | Security Context policies for controller main container. See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls # |
| frds.dnsConfig | object | `{}` | Optionally customize the pod dnsConfig. |
| frds.dnsPolicy | string | `"ClusterFirst"` | Optionally change this to ClusterFirstWithHostNet in case you have 'hostNetwork: true'. By default, while using host network, name resolution uses the host's DNS. If you wish nginx-controller to keep resolving names inside the k8s network, use ClusterFirstWithHostNet. |
| frds.env | object | `{"DS_GROUP_ID":"DE"}` | defaults value to add to the main config map |
| frds.existingPsp | string | `""` | Use an existing PSP instead of creating one |
| frds.hostNetwork | bool | `false` | Required for use with CNI based kubernetes installations (such as ones set up by kubeadm), since CNI and hostport don't mix yet. Can be deprecated once https://github.com/kubernetes/kubernetes/issues/23920 is merged |
| frds.hostname | object | `{}` | Optionally customize the pod hostname. |
| frds.image.allowPrivilegeEscalation | bool | `true` |  |
| frds.image.chroot | bool | `false` |  |
| frds.image.imagePullPolicy | string | `"IfNotPresent"` |  |
| frds.image.repository | string | `"darkedges-devspace-forgerock"` |  |
| frds.image.runAsUser | int | `11111` |  |
| frds.image.tag | string | `"7.2.0"` |  |
| frds.init.env | string | `nil` | defaults value to add to the init config map |
| frds.instance.keystore.password | string | `"changeit"` | Password for the keystore |
| frds.instance.name | string | `nil` |  |
| frds.instance.type | string | `"development"` | should be one of cts, amconfig, development, identity, replication |
| frds.keda.apiVersion | string | `"keda.sh/v1alpha1"` |  |
| frds.keda.behavior | object | `{}` |  |
| frds.keda.cooldownPeriod | int | `300` |  |
| frds.keda.enabled | bool | `false` |  |
| frds.keda.maxReplicas | int | `11` |  |
| frds.keda.minReplicas | int | `1` |  |
| frds.keda.pollingInterval | int | `30` |  |
| frds.keda.restoreToOriginalReplicaCount | bool | `false` |  |
| frds.keda.scaledObject.annotations | object | `{}` |  |
| frds.keda.triggers | list | `[]` |  |
| frds.labels | object | `{}` | Labels to be added to the controller Deployment or DaemonSet and other resources that do not have option to specify labels # |
| frds.lifecycle | object | `{"preStop":{"exec":{"command":["/opt/frds/docker-entrypoint.sh stop"]}}}` | Improve connection draining when ingress controller pod is deleted using a lifecycle hook: With this new hook, we increased the default terminationGracePeriodSeconds from 30 seconds to 300, allowing the draining of connections up to five minutes. If the active connections end before that, the pod will terminate gracefully at that time. To effectively take advantage of this feature, the Configmap feature worker-shutdown-timeout new value is 240s instead of 10s. # |
| frds.livenessProbe.failureThreshold | int | `5` |  |
| frds.livenessProbe.initialDelaySeconds | int | `10` |  |
| frds.livenessProbe.periodSeconds | int | `10` |  |
| frds.livenessProbe.successThreshold | int | `1` |  |
| frds.livenessProbe.tcpSocket.port | int | `1636` |  |
| frds.livenessProbe.timeoutSeconds | int | `1` |  |
| frds.minAvailable | int | `1` |  |
| frds.minReadySeconds | int | `0` | `minReadySeconds` to avoid killing pods before we are ready # |
| frds.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | Node labels for controller pod assignment # Ref: https://kubernetes.io/docs/user-guide/node-selection/ # |
| frds.persistentVolume.schema.storageClassName | string | `nil` | what storage class to use |
| frds.persistentVolume.schema.storageSize | string | `"100Mi"` | size to be requested. |
| frds.podSecurityContext | object | `{}` | Security Context policies for controller pods See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls # |
| frds.profiles.amconfig.backendName | string | `"cfgStore"` | backend name used for amconfig profile |
| frds.profiles.amconfig.baseDn | string | `"dc=amconfig"` | base dn used for amconfig profile |
| frds.profiles.cts.backendName | string | `"amCts"` | backend name used for cts profile |
| frds.profiles.cts.baseDn | string | `"ou=tokens"` | base dn used for cts profile |
| frds.profiles.cts.tokenExpirationPolicy | string | `"ds"` | https://backstage.forgerock.com/docs/ds/7.2/install-guide/setup-profiles.html#am-cts-6.5.0 |
| frds.profiles.identity.backendName | string | `"amIdentityStore"` | backend name used for identity profile |
| frds.profiles.identity.baseDn | string | `"ou=identities"` | base dn used for identity profile |
| frds.proxy.enabled | bool | `false` | is this a proxy server |
| frds.readinessProbe.failureThreshold | int | `3` |  |
| frds.readinessProbe.initialDelaySeconds | int | `10` |  |
| frds.readinessProbe.periodSeconds | int | `10` |  |
| frds.readinessProbe.successThreshold | int | `1` |  |
| frds.readinessProbe.tcpSocket.port | int | `1636` |  |
| frds.readinessProbe.timeoutSeconds | int | `1` |  |
| frds.replicaCount | int | `1` | number of replicas |
| frds.resources.requests.cpu | string | `"100m"` |  |
| frds.resources.requests.memory | string | `"90Mi"` |  |
| frds.secrets.amconfig.password | string | `"Passw0rd"` | amconfig admin user password |
| frds.secrets.cts.password | string | `"Passw0rd"` | cts admin user password |
| frds.secrets.deploymentkey.password | string | `"Passw0rd"` | Deployment Key password |
| frds.secrets.deploymentkey.value | string | `"AKtnvIyweZddXIA2jL4hq6F5Bn7C1Q5CBVN1bkVDfvPByQLPrt_1mJw"` | Deployment Key value |
| frds.secrets.directorymanager.password | string | `"Passw0rd"` | uid=admin password |
| frds.secrets.identity.password | string | `"Passw0rd"` | ideneity admin user password |
| frds.secrets.monitor.password | string | `"Passw0rd"` | uid=minotir password |
| frds.services | object | `{}` | list of services that this instance will wait for. # Useful for when you need to wait for a replication server to become available |
| frds.sysctls | object | `{}` | See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls |
| frds.terminationGracePeriodSeconds | int | `300` | used by the statefulset to see how many seconds should be allowed for a graceful termination |
| frds.tolerations | list | `[]` | Node tolerations for server scheduling to nodes with taints # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ # |
| frds.topologySpreadConstraints | list | `[]` | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # |
| frds.updateStrategy | object | `{}` | The update strategy to apply to the Deployment or DaemonSet # |
| frds.useKeystore | bool | `false` | has a keystore been generated and provided |
| frds.volumeClaimTemplates.data.storageClassName | string | `nil` | what storage class to use |
| frds.volumeClaimTemplates.data.storageSize | string | `"100Mi"` | size to be requested. |
| imagePullSecrets | list | `[]` | Optional array of imagePullSecrets containing private registry credentials # Ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| podSecurityPolicy.enabled | bool | `false` |  |
| rbac.create | bool | `true` |  |
| rbac.scope | bool | `false` |  |
| revisionHistoryLimit | int | `10` | Rollback limit # |
| serviceAccount.annotations | object | `{}` | Annotations for the controller service account |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

