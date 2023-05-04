#!/bin/bash

## USAGE
function usage() {
    echo
    echo "Usage:"
    echo " $0 [command] [options]"
    echo " $0 --help"
    echo
    echo "Example:"
    echo " $0 demo1"
    echo
    echo "COMMANDS:"
    echo "   demo1          Demo 1 - GitOps Application with Kustomize   "
    echo "   demo2          Demo 2 - GitOps Application with Kustomize    "
    echo "   demo3          Demo 3 - GitOps Application with Kustomize                          "
    echo "   demo4          Demo 4 - GitOps Application with Kustomize    "
    echo "   demo5          Demo 5 - GitOps Application with Kustomize                          "
    echo "   demo6          Demo 6 - GitOps Application with Kustomize    "
    echo "   demoX-delete   Delete ARO4 cluster                          "
    echo
}

while :; do
    case $1 in
        demo1)
            ARG_COMMAND=demo1
            ;;
        demo2)
            ARG_COMMAND=demo2
            ;;
        demo3)
            ARG_COMMAND=demo3
            ;;
        demo4)
            ARG_COMMAND=demo4
            ;;
        demo5)
            ARG_COMMAND=demo5
            ;;
        demo6)
            ARG_COMMAND=demo6
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *) # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done

function demo1() {
    kubectl apply -f demo1/bgdk-app.yaml
    kubectl patch app bgdk-app -n argocd \
    -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
}

function demo2() {
    kubectl apply -f demo2/todo-application.yaml
    kubectl patch app todo-app -n argocd \ 
    -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
}

function demo3() {
    kubectl apply -k demo3/deploy/
}

function demo1-delete() {
    kubectl delete -f demo1/bgdk-app.yaml
}

function demo2-delete() {
    kubectl delete -f demo2/todo-application.yaml
}

function demo3-delete() {
    kubectl demo -k deploy/

}


## MAIN
case "$ARG_COMMAND" in
    demo1)
        echo "Deploying Demo1 - GitOps Application with Kustomize"
        demo1
        echo
        echo "Completed successfully!"
        ;;

    demo2)
        echo "Deploying Demo2 - Controlling Order within GitOps deployments"
        demo2
        echo
        echo "Completed successfully!"
        ;;

    demo3)
        echo "Deploying Demo3 - Managing GitOps Apps at scale"
        demo3
        echo
        echo "Completed successfully!"
        ;;

    demo4)
        echo "Deploying Demo4 - GitOps Cluster Deployment Strategies"
        demo4
        echo
        echo "Completed successfully!"
        ;;

    demo5)
        echo "Deploying Demo5 - GitOps Application with Kustomize"
        demo5
        echo
        echo "Completed successfully!"
        ;;

    demo6)
        echo "Deploying Demo6 - GitOps Application with Kustomize"
        demo6
        echo
        echo "Completed successfully!"
        ;;

    demo1-delete)
        echo "Deleting Demo1"
        demo1-delete
        echo
        echo "Completed successfully!"
        ;;

    *)
        echo "Invalid command specified: '$ARG_COMMAND'"
        usage
        ;;
esac