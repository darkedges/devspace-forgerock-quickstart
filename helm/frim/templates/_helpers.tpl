{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "forgerock.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "forgerock.fullname" -}}
{{- if .Values.frim.fullnameOverride -}}
{{- .Values.frim.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "frim" | trunc 63 | trimSuffix "-" -}}
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
{{- if .Values.frim.serviceAccount.enabled -}}
    {{ default (include "forgerock.fullname" .) .Values.frim.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.frim.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "forgerock.serviceName" -}}
{{- $service := index . 0 -}}
{{- $root := index . 1 -}}
{{- $key := get $root.Values.frim.services $service -}}
{{- $releaseName := default $root.Release.Name $key.releaseNameOverride -}}
{{ printf "%s-%s" $releaseName $key.name }}
{{- end -}}

{{- define "forgerock.frdsHost" -}}
{{- $service := index . 0 -}}
{{- $root := index . 1 -}}
{{- $key := get $root.Values.frim.services $service -}}
{{- $releaseName := default $root.Release.Name $key.releaseNameOverride -}}
{{ printf "%s-%s-0.%s-%s" $releaseName $key.name $releaseName $key.name }}
{{- end -}}

{{- define "forgerock.serviceDetail" -}}
{{- $service := index . 0 -}}
{{- $detail := index . 1 -}}
{{- $root := index . 2 -}}
{{- $key := get $root.Values.frim.services $service -}}
{{ printf "%s" (get $key.details $detail) }}
{{- end -}}

{{- define "forgerock.waitfor" -}}
{{- $releaseName := .Release.Name -}}
{{- $waitfor := list -}}
{{- range $key, $val := .Values.frim.services -}}
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

{{/*
Container SecurityContext.
*/}}
{{- define "frim.containerSecurityContext" -}}
{{- if .Values.frim.containerSecurityContext -}}
{{- toYaml .Values.frim.containerSecurityContext -}}
{{- else -}}
capabilities:
  drop:
  - ALL
  add:
  - NET_BIND_SERVICE
  {{- if .Values.frim.image.chroot }}
  - SYS_CHROOT
  {{- end }}
runAsUser: {{ .Values.frim.image.runAsUser }}
allowPrivilegeEscalation: {{ .Values.frim.image.allowPrivilegeEscalation }}
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
{{- if .Values.frim.commonLabels}}
{{ toYaml .Values.frim.commonLabels }}
{{- end }}
{{- end -}}