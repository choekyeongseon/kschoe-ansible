#! /bin/bash

HARBORURL=harbor.rhel.test.com

PROJECTAPIPATH=https://$HARBORURL/api/v2.0/projects
publicprojectarrays=(argocd ingress-nginx prometheus tekton-pipeline tekton-triggers secloudit-registry-agent calico kubernetes-install istio-system cluster-logging nfs-server secloudit-util helm-packages metrics-server kafka dns mysql)

for var in "${publicprojectarrays[@]}"
do
    curl -k -u 'admin:qwe1212!Q' -X 'POST' \
    $PROJECTAPIPATH \
    -w " - status code: %{http_code}, sizes: %{size_request}/%{size_download}" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"project_name": "'"$var"'","metadata": {"public": "true"},"storage_limit": -1}'
done

privateprojectarrays=(secloudit secloudit-java secloudit-2.2-dev)

for var in "${privateprojectarrays[@]}"
do
    curl -k -u 'admin:qwe1212!Q' -X 'POST' \
    $PROJECTAPIPATH \
    -w " - status code: %{http_code}, sizes: %{size_request}/%{size_download}" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{"project_name": "'"$var"'","metadata": {"public": "false"},"storage_limit": -1}'
done

echo ''

PROJECT_GET_APIPATH=https://$HARBORURL/api/v2.0/projects
curl -k -u 'admin:qwe1212!Q' -X 'GET' \
  $PROJECT_GET_APIPATH \
  -H 'accept: application/json' \
