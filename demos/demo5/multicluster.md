## Adding multiple Kubernetes and OpenShift clusters to ArgoCD

## Login into ArgoCD server with ArgoCD CLI

```sh
kubectl cluster-info --context kind-gitops
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
argocd login --insecure --grpc-web argocd.rober.lab --username admin --password $argoPass
argocd cluster list
```

## Adding On-Premise OpenShift

* Install oc client:

```bash
sudo dnf install telnet wget bash-completion -y
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar -xvf openshift-client-linux.tar.gz
sudo mv oc kubectl /usr/bin/
oc completion bash > oc_bash_completion
sudo cp oc_bash_completion /etc/bash_completion.d/
````

* Create the kubeconfig:

```sh
touch /var/tmp/lab-kubeconfig
export KUBECONFIG=/var/tmp/lab-kubeconfig
kubectl login --username xxx --password xxx --server=xxx
kubectl config rename-context $(oc config current-context) cluster1
kubectl config use-context cluster1
```

* Add the k8s cluster credentials into ArgoCD server:

```sh
argocd cluster add cluster1
```

* Check the list of clusters in ArgoCD:

```sh
argocd cluster list
```

## Adding ROSA into ArgoCD

* Create the kubeconfig:

```sh
touch /var/tmp/lab-kubeconfig
export KUBECONFIG=/var/tmp/lab-kubeconfig
kubectl login --username cluster-admin --password xxx --server=xxx
kubectl config rename-context $(oc config current-context) cluster2
kubectl config use-context cluster2
```

* Add the k8s cluster credentials into ArgoCD server:

```sh
argocd cluster add cluster2
```

* Check the list of clusters in ArgoCD:

```sh
argocd cluster list
```

## Adding AKS into ArgoCD

* Add the Kubeconfig AKS credentials:

```sh
export KUBECONFIG=/var/tmp/lab-kubeconfig
az aks get-credentials --resource-group rcs-rg --name rcs-test
kubectl config rename-context $(oc config current-context) cluster3
kubectl config use-context cluster3
kubectl get nodes
```

* Add the k8s cluster credentials into ArgoCD server:

```sh
argocd cluster add cluster3
```

* Check the list of clusters in ArgoCD:

```sh
argocd cluster list
```

## Adding ARO into ArgoCD

* Create the kubeconfig:

```sh
touch /var/tmp/lab-kubeconfig
export KUBECONFIG=/var/tmp/lab-kubeconfig
kubectl login --username cluster-admin --password xxx --server=xxx
kubectl config rename-context $(oc config current-context) cluster4
kubectl config use-context cluster4
```

* Add the k8s cluster credentials into ArgoCD server:

```sh
argocd cluster add cluster4
```

* Check the list of clusters in ArgoCD:

```sh
argocd cluster list
```