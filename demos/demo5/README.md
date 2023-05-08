# Demo 5 - GitOps Multi Cluster & Multi-Environment Strategies

## Patch the Cluster Managed Secrets in ArgoCD  

* Patch the AKS cluster as dev:

```bash
DEV=$(kubectl get secret -n argocd | grep azm | awk '{ print $1 }')
kubectl patch secret -n argocd $DEV -p '{"metadata":{"labels":{"dev":"true"}}}'
```

* Patch the On-Prem k8s/OCP cluster as staging:

```bash
STAGING=$(kubectl get secret -n argocd | grep ocp4 | awk '{ print $1 }')
kubectl patch secret $STAGING -n argocd -p '{"metadata":{"labels":{"staging":"true"}}}'
```

* Patch the ROSA/ARO clusters as prod:

```bash
PROD=$(kubectl get secret -n argocd | grep 'rosa\|aro' | awk '{ print $1 }')
kubectl patch secret $PROD -n argocd -p '{"metadata":{"labels":{"prod":"true"}}}'
```

## Add new Managed clusters into ArgoCD

* Follow the [Managed Clusters into ArgoCD guide](../bootstrap/multicluster.md)

NOTE: if you did this step in the demo2, skip the previous guide.

* Check the existing ArgoCD Managed clusters available:

```
argocd cluster list
SERVER                                                     NAME        VERSION  STATUS      MESSAGE
https://api.cluster-35d4.35d4.xxxx.opentlc.com:6443  cluster2    1.20     Successful
https://api.k8s.xxxx.com:6443                         cluster1    1.21     Successful
https://kubernetes.default.svc                             in-cluster  1.20     Successful
```

## Deploy Applications in Multi Cluster Environment

```
cd ~/CdCon23-GitOpsMultiCluster/demos/demo5/
kubectl apply -k deploy
```

## Delete ApplicationSet for Apps

For delete all the multicluster & multienv environment:

```
kubectl delete applicationset -n argocd --all
```
