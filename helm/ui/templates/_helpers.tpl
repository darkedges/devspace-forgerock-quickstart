{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "forgerock.name" -}}
{{- default .Chart.Name .Values.platform.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "forgerock.fullname" -}}
{{- if .Values.platform.fullnameOverride -}}
{{- .Values.platform.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "ui" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "forgerock.admin.fullname" -}}
{{- if .Values.platform.fullnameOverride -}}
{{- .Values.platform.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "admin-ui" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "forgerock.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "forgerock.serviceAccountName" -}}
{{- if .Values.platform.serviceAccount.enabled -}}
    {{ default (include "forgerock.fullname" .) .Values.platform.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.platform.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "forgerock.waitfor" -}}
{{- $releaseName := .Release.Name -}}
{{- $waitfor := list -}}
{{- range $key, $val := .Values.platform.services -}}
{{- if $val.waitfor -}}
    {{- $releaseName := default $releaseName $val.releaseNameOverride -}}
    {{- $waitfor = append $waitfor (printf "- -%s=%s-%s" $val.waitfor $releaseName $val.name) -}}
    {{- end -}}
{{- end -}}   
{{- $waitfor := uniq $waitfor -}}
{{ printf "args:" }}
{{- range $val := $waitfor }}
    {{ printf "%s" $val | indent 8  }}
{{- end }} 
{{- end -}}

{{- define "forgerock.uiSSL" -}}
{{- $service := index . 0 -}}
{{- $root := index . 1 -}}
{{- $key := get $root.Values.platform.services $service -}}
{{- $releaseName := default $root.Release.Name $key.releaseNameOverride -}}
{{- if $key.ssl -}}
"{{ printf "SSL" }}"
{{- else -}}
"{{ printf "SIMPLE" }}"
{{- end -}}
{{- end -}}

{{/*
Container SecurityContext.
*/}}
{{- define "admin.containerSecurityContext" -}}
{{- if .Values.admin.containerSecurityContext -}}
{{- toYaml .Values.admin.containerSecurityContext -}}
{{- else -}}
capabilities:
  drop:
  - ALL
  add:
  - NET_BIND_SERVICE
  {{- if .Values.admin.image.chroot }}
  - SYS_CHROOT
  {{- end }}
runAsUser: {{ .Values.admin.image.runAsUser }}
allowPrivilegeEscalation: {{ .Values.admin.image.allowPrivilegeEscalation }}
{{- end }}
{{- end -}}

{{/*
Container SecurityContext.
*/}}
{{- define "enduser.containerSecurityContext" -}}
{{- if .Values.enduser.containerSecurityContext -}}
{{- toYaml .Values.enduser.containerSecurityContext -}}
{{- else -}}
capabilities:
  drop:
  - ALL
  add:
  - NET_BIND_SERVICE
  {{- if .Values.enduser.image.chroot }}
  - SYS_CHROOT
  {{- end }}
runAsUser: {{ .Values.enduser.image.runAsUser }}
allowPrivilegeEscalation: {{ .Values.enduser.image.allowPrivilegeEscalation }}
{{- end }}
{{- end -}}

{{/*
Container SecurityContext.
*/}}
{{- define "login.containerSecurityContext" -}}
{{- if .Values.login.containerSecurityContext -}}
{{- toYaml .Values.login.containerSecurityContext -}}
{{- else -}}
capabilities:
  drop:
  - ALL
  add:
  - NET_BIND_SERVICE
  {{- if .Values.login.image.chroot }}
  - SYS_CHROOT
  {{- end }}
runAsUser: {{ .Values.login.image.runAsUser }}
allowPrivilegeEscalation: {{ .Values.login.image.allowPrivilegeEscalation }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "forgerock.selectorLabels" -}}
app.kubernetes.io/name: {{ include "forgerock.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "forgerock.labels" -}}
helm.sh/chart: {{ include "forgerock.chart" . }}
{{ include "forgerock.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ template "forgerock.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.platform.commonLabels}}
{{ toYaml .Values.platform.commonLabels }}
{{- end }}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "forgerock.admin.selectorLabels" -}}
app.kubernetes.io/name: {{ include "forgerock.admin.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "forgerock.admin.labels" -}}
helm.sh/chart: {{ include "forgerock.chart" . }}
{{ include "forgerock.admin.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ template "forgerock.admin.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}