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
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "forgerock.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "forgerock.serviceName" -}}
{{- $service := index . 0 -}}
{{- $root := index . 1 -}}
{{- $key := get $root.Values.services $service -}}
{{- $releaseName := default $root.Release.Name $key.releaseNameOverride -}}
{{ printf "%s-%s" $releaseName $key.name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "forgerock.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "forgerock.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
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