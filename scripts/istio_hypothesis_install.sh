#!/usr/bin/env bash

ISTIO_VERSION=0.6.0
ISTIO_HOME=${HOME}/istio-${ISTIO_VERSION}
export PATH="$PATH:${ISTIO_HOME}/bin"
cd ${ISTIO_HOME}

oc new-project hypothesis
oc adm policy add-scc-to-user privileged -z default -n hypothesis

curl -o manager_api_image_template.yaml https://raw.githubusercontent.com/fabric8-hdd/fabric8-hypothesis-manager-api-image/master/openshift/template.yaml
curl -o manager_api_image.env https://raw.githubusercontent.com/fabric8-hdd/fabric8-hypothesis-manager-api-image/master/openshift/supervisor.env
oc process -f manager_api_image_template.yaml --param-file manager_api_image.env > manager_api_template.json
oc apply -f <(istioctl kube-inject -f manager_api_template.json) -n hypothesis

curl -o measurements_api_image_template.yaml https://raw.githubusercontent.com/fabric8-hdd/fabric8-hypothesis-measurements-api-image/master/openshift/template.yaml
curl -o measurements_api_image.env https://raw.githubusercontent.com/fabric8-hdd/fabric8-hypothesis-measurements-api-image/master/openshift/supervisor.env
oc process -f measurements_api_image_template.yaml --param-file measurements_api_image.env > measurements_api_template.json
oc apply -f <(istioctl kube-inject -f measurements_api_template.json) -n hypothesis

curl -o data_api_image_template.yaml https://raw.githubusercontent.com/fabric8-hdd/fabric8-hypothesis-data-api-image/master/openshift/template.yaml
curl -o data_api_image.env https://raw.githubusercontent.com/fabric8-hdd/fabric8-hypothesis-data-api-image/master/openshift/data-api.env
oc process -f data_api_image_template.yaml --param-file data_api_image.env > data_api_template.json
oc apply -f <(istioctl kube-inject -f data_api_template.json) -n hypothesis
