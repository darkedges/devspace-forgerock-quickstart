# frim

[forgerock-identity-manager](https://github.com/darkedges/devspace-forgerock-quickstart) ForgeRock Identity Manager Helm Chart for Kubernetes.

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

## Prerequisites

- Chart version 1.x.x and above: Kubernetes v1.19+
- For Local Development / Deployment a FRIM image is required

    ```console
    git clone https://github.com/darkedges/devspace-forgerock-quickstart
    cd devspace-forgerock-quickstart/docker/frim
    docker build -t devspace-forgerock-quickstart/idm:7.2.0 .
    ```

## Install Chart

**Important:** only helm3 is supported

```console
git clone https://github.com/darkedges/devspace-forgerock-quickstart
cd devspace-forgerock-quickstart
helm install --namespace=devspace-forgerock-quickstart --create-namespace -f values/environments/localdev/frim.yaml localdev-frim helm/frim
```

_See [configuration](#configuration) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade Chart

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

```console
cd devspace-forgerock-quickstart
helm upgrade -f values/environments/localdev/frim.yaml localdev-frim helm/frim
```

## Uninstall Chart

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

```console
cd devspace-forgerock-quickstart
helm uninstall localdev-frim
```

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run these configuration commands:

```console
helm show values helm/frim
```

## Source Code

* <https://github.com/darkedges/devspace-forgerock-quickstart/helm/frim>

## Requirements

Kubernetes: `>=1.20.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonLabels | object | `{}` |  |
| frim.affinity | object | `{}` |  |
| frim.autoscaling.behavior | object | `{}` |  |
| frim.autoscaling.enabled | bool | `false` |  |
| frim.autoscaling.maxReplicas | int | `11` |  |
| frim.autoscaling.minReplicas | int | `1` |  |
| frim.autoscaling.targetCPUUtilizationPercentage | int | `50` |  |
| frim.autoscaling.targetMemoryUtilizationPercentage | int | `50` |  |
| frim.autoscalingTemplate | list | `[]` |  |
| frim.certificate.enabled | bool | `false` | Wether to attach a certificate to ingress |
| frim.containerSecurityContext | object | `{}` | Security Context policies for controller main container. See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls # |
| frim.dnsConfig | object | `{}` | Optionally customize the pod dnsConfig. |
| frim.dnsPolicy | string | `"ClusterFirst"` | Optionally change this to ClusterFirstWithHostNet in case you have 'hostNetwork: true'. By default, while using host network, name resolution uses the host's DNS. If you wish nginx-controller to keep resolving names inside the k8s network, use ClusterFirstWithHostNet. |
| frim.env.frim.JAVA_OPTS | string | `"-Djava.awt.headless=true -Duser.home=/opt/frim/instance/data"` |  |
| frim.env.frim.LOGGING_CONFIG | string | `"-Djava.util.logging.config.file=/opt/frim/instance/data/conf/logging.properties"` |  |
| frim.env.frim.PROJECT_HOME | string | `"/opt/frim/instance/data"` |  |
| frim.env.init | list | `[]` |  |
| frim.existingPsp | string | `""` | Use an existing PSP instead of creating one |
| frim.hostNetwork | bool | `false` | Required for use with CNI based kubernetes installations (such as ones set up by kubeadm), since CNI and hostport don't mix yet. Can be deprecated once https://github.com/kubernetes/kubernetes/issues/23920 is merged |
| frim.hostname | object | `{}` | Optionally customize the pod hostname. |
| frim.image.allowPrivilegeEscalation | bool | `true` |  |
| frim.image.chroot | bool | `false` |  |
| frim.image.imagePullPolicy | string | `"IfNotPresent"` |  |
| frim.image.repository | string | `"devspace-forgerock-quickstart/idm"` |  |
| frim.image.runAsUser | int | `11111` |  |
| frim.image.tag | string | `"7.2.0"` |  |
| frim.ingress.backend.port | int | `8080` | port being used by the backend application |
| frim.ingress.backend.protocol | string | `"HTTP"` | scheme being used by the backend application |
| frim.ingress.enabled | bool | `false` | Wether to expose the service to ingress |
| frim.ingress.hosts | list | `[]` | List of hostname to use for ingress |
| frim.isStatefulSet | bool | `false` |  |
| frim.keda.apiVersion | string | `"keda.sh/v1alpha1"` |  |
| frim.keda.behavior | object | `{}` |  |
| frim.keda.cooldownPeriod | int | `300` |  |
| frim.keda.enabled | bool | `false` |  |
| frim.keda.maxReplicas | int | `11` |  |
| frim.keda.minReplicas | int | `1` |  |
| frim.keda.pollingInterval | int | `30` |  |
| frim.keda.restoreToOriginalReplicaCount | bool | `false` |  |
| frim.keda.scaledObject.annotations | object | `{}` |  |
| frim.keda.triggers | list | `[]` |  |
| frim.keystore.password | string | `"changeit"` | Password for the keystore |
| frim.labels | object | `{}` | Labels to be added to the controller Deployment or DaemonSet and other resources that do not have option to specify labels # |
| frim.lifecycle | object | `{"preStop":{"exec":{"command":["/opt/frim/docker-entrypoint.sh","stop"]}}}` | Improve connection draining when ingress controller pod is deleted using a lifecycle hook: With this new hook, we increased the default terminationGracePeriodSeconds from 30 seconds to 300, allowing the draining of connections up to five minutes. If the active connections end before that, the pod will terminate gracefully at that time. To effectively take advantage of this feature, the Configmap feature worker-shutdown-timeout new value is 240s instead of 10s. # |
| frim.livenessProbe.failureThreshold | int | `5` |  |
| frim.livenessProbe.httpGet.httpHeaders[0].name | string | `"x-openidm-username"` |  |
| frim.livenessProbe.httpGet.httpHeaders[0].value | string | `"anonymous"` |  |
| frim.livenessProbe.httpGet.httpHeaders[1].name | string | `"x-openidm-password"` |  |
| frim.livenessProbe.httpGet.httpHeaders[1].value | string | `"anonymous"` |  |
| frim.livenessProbe.httpGet.path | string | `"/openidm/info/ping"` |  |
| frim.livenessProbe.httpGet.port | int | `8443` |  |
| frim.livenessProbe.httpGet.scheme | string | `"HTTPS"` |  |
| frim.livenessProbe.initialDelaySeconds | int | `10` |  |
| frim.livenessProbe.periodSeconds | int | `10` |  |
| frim.livenessProbe.successThreshold | int | `1` |  |
| frim.livenessProbe.timeoutSeconds | int | `1` |  |
| frim.minAvailable | int | `1` |  |
| frim.minReadySeconds | int | `0` | `minReadySeconds` to avoid killing pods before we are ready # |
| frim.nodeSelector | object | `{"kubernetes.io/os":"linux"}` | Node labels for controller pod assignment # Ref: https://kubernetes.io/docs/user-guide/node-selection/ # |
| frim.podSecurityContext | object | `{}` | Security Context policies for controller pods See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls # |
| frim.rbac.enabled | bool | `true` | whether to create roles and bindings |
| frim.readinessProbe.failureThreshold | int | `5` |  |
| frim.readinessProbe.httpGet.httpHeaders[0].name | string | `"x-openidm-username"` |  |
| frim.readinessProbe.httpGet.httpHeaders[0].value | string | `"anonymous"` |  |
| frim.readinessProbe.httpGet.httpHeaders[1].name | string | `"x-openidm-password"` |  |
| frim.readinessProbe.httpGet.httpHeaders[1].value | string | `"anonymous"` |  |
| frim.readinessProbe.httpGet.path | string | `"/openidm/info/ping"` |  |
| frim.readinessProbe.httpGet.port | int | `8443` |  |
| frim.readinessProbe.httpGet.scheme | string | `"HTTPS"` |  |
| frim.readinessProbe.initialDelaySeconds | int | `10` |  |
| frim.readinessProbe.periodSeconds | int | `10` |  |
| frim.readinessProbe.successThreshold | int | `1` |  |
| frim.readinessProbe.timeoutSeconds | int | `1` |  |
| frim.replicaCount | int | `1` | number of replicas |
| frim.resources.requests.cpu | string | `"100m"` |  |
| frim.resources.requests.memory | string | `"90Mi"` |  |
| frim.secrets.provisioner.ldap.userStore.password | string | `"Passw0rd"` | see docker FRAM_CFG_STORE_DIR_MGR_PWD |
| frim.secrets.provisioner.ldap.userStore.uid | string | `"uid=am-identity-bind-account,ou=admins,ou=identities"` | see docker FRAM_CFG_STORE_DIR_MGR |
| frim.secrets.repo.password | string | `"Passw0rd"` | see docker FRAM_CFG_STORE_DIR_MGR_PWD |
| frim.secrets.repo.uid | string | `"frim"` | see docker FRAM_CFG_STORE_DIR_MGR |
| frim.serviceAccount.annotations | object | `{}` | list of annotations to attach to a service account |
| frim.serviceAccount.automountServiceAccountToken | bool | `true` |  |
| frim.serviceAccount.enabled | bool | `true` | whether to create services accounts |
| frim.serviceAccount.name | string | `nil` |  |
| frim.services | object | `{}` | map of multiple service details that can be connected to |
| frim.sysctls | object | `{}` | See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using sysctls |
| frim.terminationGracePeriodSeconds | int | `300` |  |
| frim.tolerations | list | `[]` | Node tolerations for server scheduling to nodes with taints # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ # |
| frim.topologySpreadConstraints | list | `[]` | Topology spread constraints rely on node labels to identify the topology domain(s) that each Node is in. # Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ # |
| frim.updateStrategy | object | `{}` | The update strategy to apply to the Deployment or DaemonSet # |
| frim.useKeystore | bool | `false` | has a keystore been generated and provided |
| frim.volumeClaimTemplates.data.storageClassName | string | `nil` | what storage class to use |
| frim.volumeClaimTemplates.data.storageSize | string | `"100Mi"` | size to be requested. |
| imagePullSecrets | list | `[]` | Optional array of imagePullSecrets containing private registry credentials # Ref: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| podSecurityPolicy.enabled | bool | `false` |  |
| revisionHistoryLimit | int | `10` | Rollback limit # |

