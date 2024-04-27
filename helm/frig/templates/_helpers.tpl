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
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Container SecurityContext.
*/}}
{{- define "frig.containerSecurityContext" -}}
{{- if .Values.frig.containerSecurityContext -}}
{{- toYaml .Values.frig.containerSecurityContext -}}
{{- else -}}
capabilities:
  drop:
  - ALL
  add:
  - NET_BIND_SERVICE
  {{- if .Values.frig.image.chroot }}
  - SYS_CHROOT
  {{- end }}
runAsUser: {{ .Values.frig.image.runAsUser }}
allowPrivilegeEscalation: {{ .Values.frig.image.allowPrivilegeEscalation }}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "forgerock.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
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
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "forgerock.serviceAccountName" -}}
{{- if .Values.frig.serviceAccount.create -}}
    {{ default (include "forgerock.fullname" .) .Values.frig.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.frig.serviceAccount.name }}
{{- end -}}
{{- end -}}