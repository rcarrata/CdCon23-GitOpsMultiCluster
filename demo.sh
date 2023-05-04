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
    echo "   demo1          Demo 1 - GitOps Application with Kustomize"
    echo "   demo2          Demo 2 - Deploying GitOps Apps in Remote Clusters"
    echo "   demo3          Demo 3 - Managing GitOps Apps at scale"
    echo "   demo4          Demo 4 - GitOps Multi-Cluster Deployment Strategies"
    echo "   demo5          Demo 5 - Promotion between GitOps environments"
    echo "   demoX-delete   Delete DemoX cluster - specify num of demo"
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

# Deploy DemoX functions
function demo1() {
    kubectl apply -f demos/demo1/bgdk-app.yaml
    kubectl patch app bgdk-app -n argocd \
    -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
}

function demo2() {
    kubectl apply -f demos/demo2/todo-application.yaml
    kubectl patch app todo-app -n argocd \ 
    -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
}

function demo3() {
    kubectl apply -k demos/demo3/deploy/
}

function demo4() {
    kubectl apply -k demos/demo4/deploy/
}

function demo5() {
    kubectl apply -k demos/demo5/deploy/
}


## Delete Functions
function demo1-delete() {
    kubectl delete -f demos/demo1/bgdk-app.yaml
}

function demo2-delete() {
    kubectl delete -f demos/demo2/todo-application.yaml
}

function demo3-delete() {
    kubectl delete -k demos/demo3/deploy/
}

function demo4-delete() {
    kubectl delete -k demos/demo4/deploy/
}


function demo5-delete() {
    kubectl delete -k demos/demo5/deploy/
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
        echo "Deploying Demo2 - Deploying GitOps Apps in Remote Clusters"
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
        echo "Deploying Demo4 - GitOps Multi-Cluster Deployment Strategies"
        demo4
        echo
        echo "Completed successfully!"
        ;;

    demo5)
        echo "Deploying Demo5 - Promotion between GitOps environments"
        demo5
        echo
        echo "Completed successfully!"
        ;;

    demo1-delete)
        echo "Deleting Demo1"
        demo1-delete
        echo
        echo "Completed successfully!"
        ;;

    demo2-delete)
        echo "Deleting Demo2"
        demo2-delete
        echo
        echo "Completed successfully!"
        ;;

    demo3-delete)
        echo "Deleting Demo3"
        demo3-delete
        echo
        echo "Completed successfully!"
        ;;

    demo4-delete)
        echo "Deleting Demo4"
        demo4-delete
        echo
        echo "Completed successfully!"
        ;;

    demo5-delete)
        echo "Deleting Demo5"
        demo5-delete
        echo
        echo "Completed successfully!"
        ;;

    *)
        echo "Invalid command specified: '$ARG_COMMAND'"
        usage
        ;;
esac