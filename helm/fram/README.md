# fram

[forgerock-access-manager](https://github.com/darkedges/devspace-forgerock-quickstart) ForgeRock Access Manager Helm Chart for Kubernetes.

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

## Prerequisites

- Chart version 1.x.x and above: Kubernetes v1.19+
- For Local Development / Deployment a FRAM image is required

    ```console
    git clone https://github.com/darkedges/devspace-forgerock-quickstart
    cd devspace-forgerock-quickstart/docker/fram
    docker build -t devspace-forgerock-quickstart/am:7.2.0 .
    ```

## Install Chart

**Important:** only helm3 is supported

```console
git clone https://github.com/darkedges/devspace-forgerock-quickstart
cd devspace-forgerock-quickstart
helm install --namespace=devspace-forgerock-quickstart --create-namespace -f values/environments/localdev/fram.yaml localdev-fram helm/fram
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade Chart

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

```console
cd devspace-forgerock-quickstart
helm upgrade -f values/environments/localdev/fram.yaml localdev-fram helm/fram
```

## Uninstall Chart

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

```console
cd devspace-forgerock-quickstart
helm uninstall localdev-fram
```

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run these configuration commands:

```console
helm show values helm/fram
```

## Source Code

* <https://github.com/darkedges/devspace-forgerock-quickstart/helm/fram>

## Requirements

Kubernetes: `>=1.20.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonLabels | object | `{}` |  |
| fram.affinity | object | `{}` |  |
| fram.autoscaling.behavior | object | `{}` |  |
| fram.autoscaling.enabled | bool | `false` |  |
| fram.autoscaling.enabled | bool | `false` |  |
| fram.autoscaling.maxReplicas | int | `11` |  |
| fram.autoscaling.minReplicas | int | `1` |  |
| fram.autoscaling.targetCPUUtilizationPercentage | int | `50` |  |
| fram.autoscaling.targetMemoryUtilizationPercentage | int | `50` |  |
| fram.autoscalingTemplate | list | `[]` |  |
| fram.certificate.enabled | bool | `false` | Wether to attach a certificate to ingress |
| fram.containerSecurityContext | object | `{}` | Security Context policies for controller main container. See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls # |
| fram.dnsConfig | object | `{}` | Optionally customize the pod dnsConfig. |
| fram.dnsPolicy | string | `"ClusterFirst"` | Optionally change this to ClusterFirstWithHostNet in case you have 'hostNetwork: true'. By default, while using host network, name resolution uses the host's DNS. If you wish nginx-controller to keep resolving names inside the k8s network, use ClusterFirstWithHostNet. |
| fram.existingPsp | string | `""` | Use an existing PSP instead of creating one |
| fram.hostNetwork | bool | `false` | Required for use with CNI based kubernetes installations (such as ones set up by kubeadm), since CNI and hostport don't mix yet. Can be deprecated once https://github.com/kubernetes/kubernetes/issues/23920 is merged |
| fram.hostname | object | `{}` | Optionally customize the pod hostname. |
| fram.image.allowPrivilegeEscalation | bool | `true` |  |
| fram.image.chroot | bool | `false` |  |
| fram.image.imagePullPolicy | string | `"IfNotPresent"` |  |
| fram.image.repository | string | `"devspace-forgerock-quickstart/am"` |  |
| fram.image.runAsUser | int | `11111` |  |
| fram.image.tag | string | `"7.2.0"` |  |
| fram.imagePullSecrets | list | `[]` | Optional array of imagePullSecrets containing private registry credentials # Ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| fram.ingress.backend.port | int | `8080` | port being used by the backend application |
| fram.ingress.backend.protocol | string | `"HTTP"` | scheme being used by the backend application |
| fram.ingress.enabled | bool | `false` | Wether to expose the service to ingress |
| fram.ingress.hosts | list | `[]` | List of hostname to use for ingress |
| fram.init.env | list | `[]` |  |
| fram.keda.apiVersion | string | `"keda.sh/v1alpha1"` |  |
| fram.keda.behavior | object | `{}` |  |
| fram.keda.cooldownPeriod | int | `300` |  |
| fram.keda.enabled | bool | `false` |  |
| fram.keda.maxReplicas | int | `11` |  |
| fram.keda.minReplicas | int | `1` |  |
| fram.keda.pollingInterval | int | `30` |  |
| fram.keda.restoreToOriginalReplicaCount | bool | `false` |  |
| fram.keda.scaledObject.annotations | object | `{}` |  |
| fram.keda.triggers | list | `[]` |  |
| fram.keystore.password | string | `"changeit"` | Password for the keystore |
| fram.labels | object | `{}` | Labels to be added to the controller Deployment or DaemonSet and other resources that do not have option to specify labels # |
| fram.lifecycle | object | `{"preStop":{"exec":{"command":["/opt/fram/docker-entrypoint.sh stop"]}}}` | Improve connection draining when ingress controller pod is deleted using a lifecycle hook: With this new hook, we increased the default terminationGracePeriodSeconds from 30 seconds to 300, allowing the draining of connections up to five minutes. If the active connections end before that, the pod will terminate gracefully at that time. To effectively take advantage of this feature, the Configmap feature worker-shutdown-timeout new value is 240s instead of 10s. # |
| fram.livenessProbe.failureThreshold | int | `5` |  |
| fram.livenessProbe.httpGet.path | string | `"am/json/health/live"` |  |
| fram.livenessProbe.httpGet.port | int | `8443` |  |
| fram.livenessProbe.httpGet.scheme | string | `"HTTPS"` |  |
| fram.livenessProbe.initialDelaySeconds | int | `10` |  |
| fram.livenessProbe.periodSeconds | int | `10` |  |
| fram.livenessProbe.successThreshold | int | `1` |  |
| fram.livenessProbe.timeoutSeconds | int | `1` |  |
| fram.minAvailable | int | `1` |  |
| fram.minReadySeconds | int | `0` | `minReadySeconds` to avoid killing pods before we are ready # |
| fram.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | Node labels for controller pod assignment # Ref: https://kubernetes.io/docs/user-guide/node-selection/ # |
| fram.podSecurityContext | object | `{}` | Security Context policies for controller pods See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls # |
| fram.rbac.create | bool | `true` |  |
| fram.rbac.enabled | bool | `true` | whether to create roles and bindings |
| fram.rbac.scope | bool | `false` |  |
| fram.readinessProbe.failureThreshold | int | `5` |  |
| fram.readinessProbe.httpGet.path | string | `"am/json/health/live"` |  |
| fram.readinessProbe.httpGet.port | int | `8443` |  |
| fram.readinessProbe.httpGet.scheme | string | `"HTTPS"` |  |
| fram.readinessProbe.initialDelaySeconds | int | `10` |  |
| fram.readinessProbe.periodSeconds | int | `10` |  |
| fram.readinessProbe.successThreshold | int | `1` |  |
| fram.readinessProbe.timeoutSeconds | int | `1` |  |
| fram.replicaCount | int | `1` | number of replicas |
| fram.resources.requests.cpu | string | `"100m"` |  |
| fram.resources.requests.memory | string | `"90Mi"` |  |
| fram.secrets.admin.password | string | `"Passw0rd"` | see docker FRAM_ADMIN_PASSWORD |
| fram.secrets.cfgStore.password | string | `"Passw0rd"` | see docker FRAM_CFG_STORE_DIR_MGR_PWD |
| fram.secrets.cfgStore.uid | string | `"uid=am-config,ou=admins,dc=amconfig"` | see docker FRAM_CFG_STORE_DIR_MGR |
| fram.secrets.ctsStore.password | string | `"Passw0rd"` | password for CTS Store |
| fram.secrets.ctsStore.uid | string | `"uid=openam_cts,ou=admins,ou=famrecords,ou=openam-session,ou=tokens"` | uid for CTS Store |
| fram.secrets.userStore.password | string | `"Passw0rd"` | see docker FRAM_USER_STORE_DIR_MGR_PWD |
| fram.secrets.userStore.uid | string | `"uid=am-identity-bind-account,ou=admins,ou=identities"` | see docker FRAM_USER_STORE_DIR_MGR |
| fram.serviceAccount.annotations | object | `{}` | list of annotations to attach to a service account |
| fram.serviceAccount.annotations | object | `{"helm.sh/hook":"pre-install","helm.sh/hook-delete-policy":"before-hook-creation","helm.sh/hook-weight":"-10"}` | list of annotations to attach to a service account |
| fram.serviceAccount.automountServiceAccountToken | bool | `true` |  |
| fram.serviceAccount.create | bool | `true` |  |
| fram.serviceAccount.enabled | bool | `true` | whether to create services accounts |
| fram.serviceAccount.name | string | `nil` |  |
| fram.serviceAccount.name | string | `""` |  |
| fram.services | object | `{}` | map of multiple service details that can be connected to |
| fram.stores.cfgStore.enabled | bool | `true` | config store type |
| fram.stores.cfgStore.instance | string | `"development"` |  |
| fram.stores.cfgStore.rootSuffix | string | `"dc=amconfig"` |  |
| fram.stores.ctsStore.enabled | bool | `true` | ctsStore store enabled |
| fram.stores.ctsStore.instance | string | `"development"` | ctsStore store type |
| fram.stores.ctsStore.rootSuffix | string | `"dc=cts,ou=identities"` | ctsStore store root uffix |
| fram.stores.userStore.enabled | bool | `true` | userStore store enabled |
| fram.stores.userStore.instance | string | `"development"` | userStore store type |
| fram.stores.userStore.rootSuffix | string | `"ou=identities"` | userStore store root uffix |
| fram.sysctls | object | `{}` | See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls |
| fram.terminationGracePeriodSeconds | int | `300` |  |
| fram.tolerations | list | `[]` | Node tolerations for server scheduling to nodes with taints # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ # |
| fram.topologySpreadConstraints | list | `[]` | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # |
| fram.updateStrategy | object | `{}` | The update strategy to apply to the Deployment or DaemonSet # |
| fram.useKeystore | bool | `false` | has a keystore been generated and provided |
| fram.volumeClaimTemplates.data.storageClassName | string | `nil` | what storage class to use |
| fram.volumeClaimTemplates.data.storageSize | string | `"100Mi"` | size to be requested. |
| podSecurityPolicy.enabled | bool | `false` |  |
| revisionHistoryLimit | int | `10` | Rollback limit # |

