{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "forgerock.name" -}}
{{- default .Chart.Name .Values.directory.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "forgerock.frds.ds.fullname" -}}
{{- if .Values.directory.fullnameOverride -}}
{{- .Values.directory.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name "frds" "ds" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "forgerock.frds.rs.fullname" -}}
{{- if .Values.replication.fullnameOverride -}}
{{- .Values.replication.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name "frds" "rs" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Container SecurityContext.
*/}}
{{- define "frds.containerSecurityContext" -}}
{{- if .Values.directory.containerSecurityContext -}}
{{- toYaml .Values.directory.containerSecurityContext -}}
{{- else -}}
capabilities:
  drop:
  - ALL
  add:
  - NET_BIND_SERVICE
  {{- if .Values.directory.image.chroot }}
  - SYS_CHROOT
  {{- end }}
runAsUser: {{ .Values.directory.image.runAsUser }}
allowPrivilegeEscalation: {{ .Values.directory.image.allowPrivilegeEscalation }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "forgerock.ds.selectorLabels" -}}
app.kubernetes.io/name: {{ include "forgerock.frds.ds.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "forgerock.rs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "forgerock.frds.rs.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "forgerock.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "frds.replication.bootstrap" -}}
{{- $nodeCount := .Values.replication.replicas | int }}
{{- $name := include "forgerock.frds.rs.fullname" . }}
  {{- range $index0 := until $nodeCount -}}
    {{- $index1 := $index0 | add1 -}}
{{ $name }}-{{ $index0 }}.{{ $name }}:8989{{ if ne $index1 $nodeCount }},{{ end }}
  {{- end -}}
{{- end -}}

{{- define "frds.directory.bootstrap" -}}
{{- $nodeCount := .Values.directory.replicas | int }}
{{- $name := include "forgerock.frds.ds.fullname" . }}
  {{- range $index0 := until $nodeCount -}}
    {{- $index1 := $index0 | add1 -}}
{{ $name }}-{{ $index0 }}.{{ $name }}:8989{{ if ne $index1 $nodeCount }},{{ end }}
  {{- end -}}
{{- end -}}

{{- define "forgerock.ds.waitfor" -}}
{{- $releaseName := .Release.Name -}}
{{- $rs := include "forgerock.frds.rs.fullname" . }}
{{- $waitfor := list -}}
{{- range $key, $val := .Values.services -}}
{{- if $val.waitfor -}}
    {{- $releaseName := default $releaseName $val.releaseNameOverride -}}
    {{- $waitfor = append $waitfor (printf "- -%s=%s-%s" $val.waitfor $releaseName $val.name) -}}
    {{- end -}}
{{- end -}}
{{- if ge .Values.replication.replicas 1.0 -}}
  {{- $waitfor = append $waitfor (printf "- -%s=%s" "service" $rs) -}}
{{- end -}}
{{- $waitfor := uniq $waitfor -}}
{{ printf "args:" }}
{{- range $val := $waitfor }}
    {{ printf "%s" $val | indent 8  }}
{{- end }} 
{{- end -}}

{{- define "forgerock.rs.waitfor" -}}
{{- $releaseName := .Release.Name -}}
{{- $rs := include "forgerock.frds.rs.fullname" . }}
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
{{- define "forgerock.ds.labels" -}}
helm.sh/chart: {{ include "forgerock.chart" . }}
{{ include "forgerock.ds.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ template "forgerock.frds.ds.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "forgerock.rs.labels" -}}
helm.sh/chart: {{ include "forgerock.chart" . }}
{{ include "forgerock.rs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/part-of: {{ template "forgerock.frds.rs.fullname" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "forgerock.rs.serviceAccountName" -}}
{{- if .Values.replication.serviceAccount.create -}}
    {{ default (include "forgerock.frds.rs.fullname" .) .Values.directory.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.directory.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "forgerock.ds.serviceAccountName" -}}
{{- if .Values.directory.serviceAccount.create -}}
    {{ default (include "forgerock.frds.ds.fullname" .) .Values.directory.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.directory.serviceAccount.name }}
{{- end -}}
{{- end -}}