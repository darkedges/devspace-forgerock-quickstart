{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "forgerock.name" -}}
{{- default .Chart.Name .Values.fram.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "forgerock.fullname" -}}
{{- if .Values.fram.fullnameOverride -}}
{{- .Values.fram.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "fram" | trunc 63 | trimSuffix "-" -}}
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
{{- if .Values.fram.serviceAccount.enabled -}}
    {{ default (include "forgerock.fullname" .) .Values.fram.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.fram.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "forgerock.waitfor" -}}
{{- $releaseName := .Release.Name -}}
{{- $waitfor := list -}}
{{- range $key, $val := .Values.fram.services -}}
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

{{- define "forgerock.framHost" -}}
{{- $service := index . 0 -}}
{{- $root := index . 1 -}}
{{- $key := get $root.Values.fram.services $service -}}
{{- $releaseName := default $root.Release.Name $key.releaseNameOverride -}}
"{{ printf "%s-%s-0.%s-%s" $releaseName $key.name $releaseName $key.name }}"
{{- end -}}

{{- define "forgerock.framPort" -}}
{{- $service := index . 0 -}}
{{- $root := index . 1 -}}
{{- $key := get $root.Values.fram.services $service -}}
{{- $releaseName := default $root.Release.Name $key.releaseNameOverride -}}
"{{ printf "%d" (default 389 $key.port | int) }}"
{{- end -}}

{{- define "forgerock.framSSL" -}}
{{- $service := index . 0 -}}
{{- $root := index . 1 -}}
{{- $key := get $root.Values.fram.services $service -}}
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
{{- define "fram.containerSecurityContext" -}}
{{- if .Values.fram.containerSecurityContext -}}
{{- toYaml .Values.fram.containerSecurityContext -}}
{{- else -}}
capabilities:
  drop:
  - ALL
  add:
  - NET_BIND_SERVICE
  {{- if .Values.fram.image.chroot }}
  - SYS_CHROOT
  {{- end }}
runAsUser: {{ .Values.fram.image.runAsUser }}
allowPrivilegeEscalation: {{ .Values.fram.image.allowPrivilegeEscalation }}
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
{{- if .Values.fram.commonLabels}}
{{ toYaml .Values.fram.commonLabels }}
{{- end }}
{{- end -}}