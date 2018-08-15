#!/bin/bash

echo "=== Creating podpreset binding"
kubectl create namespace test-ns
kubectl create -f config/samples/apod2-presetbinding.yaml

echo "=== Creating deployment with matching label selector"
kubectl create -f config/samples/apod2-deployment.yaml

echo "=== Executing mini-walkthrough"
GOPATH=$(go env GOPATH)
CATALOG_CODE="$GOPATH/src/github.com/kubernetes-incubator/service-catalog"
helm install "$CATALOG_CODE"/charts/ups-broker --name ups-broker --namespace ups-broker
kubectl create -f "$CATALOG_CODE"/contrib/examples/walkthrough/ups-broker.yaml
kubectl create -f "$CATALOG_CODE"/contrib/examples/walkthrough/ups-instance.yaml
kubectl create -f "$CATALOG_CODE"/contrib/examples/walkthrough/ups-binding.yaml

#echo "=== Retrieving logs from controller"
#kubectl logs -lapi=podpreset-crd -n podpreset-crd-system
