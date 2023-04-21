# Pattern 1 - Kustomize to the rescue! 


* Deploy a Kustomized Application:

```
kubectl apply -f bgdk-app.yaml
```

* [Kustomization](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/)

* [Examples Kustomize](https://github.com/kubernetes-sigs/kustomize/tree/master/examples)

* [PatchesJSON6902](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patchesjson6902/)

* [Examples Inline Patches](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/inlinePatch.md#inline-patch-for-patchesjson6902)

* [Documentation Patches](https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/patchesstrategicmerge/)

## Delete BGD and BGDK apps (in cascade)

* To delete all the objects generated in the bgd application use:

```
kubectl patch app bgd-app -n openshift-gitops -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
```