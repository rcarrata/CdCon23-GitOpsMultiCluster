# Demo 1 - GitOps Application with Kustomize

* Deploy a Kustomized Application using ArgoCD Application:

```
cd ~/CdCon23-GitOpsMultiCluster/demos/demo1/
kubectl apply -f bgdk-app.yaml
```

## Delete BGD and BGDK apps (in cascade)

* To delete all the objects generated in the bgd application use:

```
kubectl patch app bgdk-app -n argocd -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge

kubectl delete -f bgdk-app.yaml
```

## Kustomize Documentation

* [Kustomization](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/)

* [Examples Kustomize](https://github.com/kubernetes-sigs/kustomize/tree/master/examples)

* [PatchesJSON6902](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patchesjson6902/)

* [Examples Inline Patches](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/inlinePatch.md#inline-patch-for-patchesjson6902)

* [Documentation Patches](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patchesstrategicmerge/)