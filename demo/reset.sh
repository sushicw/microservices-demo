#!/bin/bash
set -ex

# For https://docs.google.com/document/d/13Qp4KItJbkrlCll63Xp65W_e2hBfbjm-gP1Naa2Xn8E/edit#

# Reset the demo scenario
# (Note that the paths and cluster here are specific to Chris)

# Make sure we're on the right cluster
gcloud container clusters get-credentials hipster-demo-3

# Reset istio version
for i in ~/istio-release/istio-1.3.1/install/kubernetes/helm/istio-init/files/crd*yaml; do kubectl apply -f $i; done
kubectl apply -f ~/istio-release/istio-1.3.1/install/kubernetes/istio-demo-auth.yaml

# Remove injection label
kubectl label namespace default istio-injection-

# Reset resources
kubectl delete -f ~/go/src/github.com/GoogleCloudPlatform/microservices-demo/demo/canary1.yaml --ignore-not-found=true
kubectl apply -f ~/go/src/github.com/GoogleCloudPlatform/microservices-demo/demo/stage1.yaml

# Reset pods
kubectl delete pods --all -n default

# Print ingress gateway for convenience
echo "Ingress gateway: " `kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`
