# Demo 3 - The GitOps Order Awakens!

## Deploy Dev Environment

```
kubectl apply -k deploy.yaml
```

## Argo App of Apps Pattern

You can create an app that creates other apps, which in turn can create other apps. This allows you to declaratively manage a group of apps that can be deployed and configured in concert.

[App of Apps Pattern Documentation](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/#app-of-apps-pattern)

## Delete App of Apps pattern

To delete the app of apps pattern, the deletion finalizer needs to be applied to each child of the app of apps, because needs to have this in order to achieve the [delete in cascade](https://argoproj.github.io/argo-cd/user-guide/app_deletion/#about-the-deletion-finalizer)

```
for i in $(kubectl get applications -n argocd | awk '{print $1}' | grep -v NAME); do kubectl patch app $i -n argocd -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge; done
```

```
kubectl delete app dev-env-app-of-apps -n argocd
```

