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

    # delete existing contents of /workspace on pod
    # except:
    #   * `./backend.tf`
    #   * `./.terraform`
    # upload contents of workspace to pod
    pushd $dir
    tar cf - $(find -name '*.tf' -o -path ./.terraform/environment) \
        | kubectl exec $POD_NAME -i -- sh -c "find . \! -name ./backend.tf -o \! -path './.terraform*' -mindepth 1 -delete && tar xof -"
    popd

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
