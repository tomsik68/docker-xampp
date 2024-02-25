{{/*
Expand the name of the chart.
*/}}
{{- define "xampp.name" -}}
{{- default .Chart.Name .Values.xamppnameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xampp.fullname" -}}
{{- if .Values.xamppfullnameOverride }}
{{- .Values.xamppfullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.xamppnameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "xampp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "xampp.labels" -}}
helm.sh/chart: {{ include "xampp.chart" . }}
{{ include "xampp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: {{ .Values.projectScope }}
{{- end }}

{{/*
Additional labels
*/}}
{{- define "xampp.additionalLabels" -}}
{{- if .Values.deployment.additionalLabels }}
{{- range $key, $val := .Values.deployment.additionalLabels }}
{{ $key }}: {{ $val | quote }}
{{- end}}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "xampp.selectorLabels" -}}
app.kubernetes.io/name: {{ include "xampp.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "xampp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "xampp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for Ingress.
*/}}
{{- define "ingress.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1/Ingress" -}}
{{- print "networking.k8s.io/v1" -}}
{{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1/Ingress" -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}
