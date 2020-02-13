#!/usr/bin/env bash

set -e

remote_cmd() {
    dir="."
    tfArgs="$*"

    if [[ $# -gt 1 ]]
    then
        lastArg=${@:$#}

        # if last arg is not a flag
        # then it's the directory arg
        if [[ $lastArg != -* ]]
        then
            dir="$lastArg"
            allButlastArg="${@:1:$(($#-1))}"
            tfArgs=$allButlastArg
        fi
    fi

    # assumes only one pod
    POD_NAME=$(kubectl get -l app.kubernetes.io/name=terraform pod -ojsonpath="{.items[0].metadata.name}")

    # uploads contents of workspace to pod
    tar cf - --exclude .terraform $dir | kubectl exec $POD_NAME -i -- tar xof - -C /workspace

    # invoke tf in pod
    exec kubectl exec $POD_NAME -- terraform $tfArgs
}

cmd="$1"
case $cmd in
    apply|destroy|force-unlock|import|init|output|plan|refresh|show|state|taint|untaint|validate)
        echo "**running remotely**"
        remote_cmd $*
        ;;
    *)
        echo "**running locally**"
        exec terraform $*
        ;;
esac
