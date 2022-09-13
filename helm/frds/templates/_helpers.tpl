{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "forgerock.name" -}}
{{- default .Chart.Name .Values.frds.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "forgerock.frds.fullname" -}}
{{- if .Values.frds.fullnameOverride -}}
{{- .Values.frds.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name "frds" .Values.frds.instance.type | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Container SecurityContext.
*/}}
{{- define "frds.containerSecurityContext" -}}
{{- if .Values.frds.containerSecurityContext -}}
{{- toYaml .Values.frds.containerSecurityContext -}}
{{- else -}}
capabilities:
  drop:
  - ALL
  add:
  - NET_BIND_SERVICE
  {{- if .Values.frds.image.chroot }}
  - SYS_CHROOT
  {{- end }}
runAsUser: {{ .Values.frds.image.runAsUser }}
allowPrivilegeEscalation: {{ .Values.frds.image.allowPrivilegeEscalation }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "forgerock.selectorLabels" -}}
app.kubernetes.io/name: {{ include "forgerock.frds.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "forgerock.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "frds.bootstrap" -}}
{{- $node := index . 0 }}
{{- $nodeCount := index . 1 | int }}
  {{- range $index0 := until $nodeCount -}}
    {{- $index1 := $index0 | add1 -}}
frds-ds-{{ $node }}-{{ $index0 }}.frds-ds-{{ $node }}:8989{{ if ne $index1 $nodeCount }},{{ end }}
  {{- end -}}
{{- end -}}

{{- define "forgerock.waitfor" -}}
{{- $releaseName := .Release.Name -}}
{{- $waitfor := list -}}
{{- range $key, $val := .Values.services -}}
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
Common labels
*/}}
{{- define "forgerock.labels" -}}
helm.sh/chart: {{ include "forgerock.chart" . }}
{{ include "forgerock.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ template "forgerock.frds.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "forgerock.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "forgerock.frds.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}