#!/usr/bin/env bash

set -e

# assumes only one pod
POD_NAME=$(kubectl get -l app.kubernetes.io/name=terraform pod -ojsonpath="{.items[0].metadata.name}")

# assumes current dir is the workspace
# uploads contents of workspace to pod
tar cf - --exclude .terraform . | kubectl exec $POD_NAME -i -- tar xof - -C /workspace

# invokes terraform with whatever args are passed in
kubectl exec $POD_NAME -- terraform $*
