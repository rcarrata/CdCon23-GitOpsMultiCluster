## Adding multiple Kubernetes and OpenShift clusters to ArgoCD

## Login into ArgoCD server with ArgoCD CLI

```sh
kubectl cluster-info --context kind-gitops
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
argocd login --insecure --grpc-web argocd.rcarrata.com --username admin --password $argoPass
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

* Create ROSA cluster

```sh
export VERSION=4.11.31 \
       ROSA_CLUSTER_NAME=rosagitops \
       AWS_ACCOUNT_ID=`aws sts get-caller-identity --query Account --output text` \
       REGION=us-east-2 \
       AWS_PAGER=""

rosa create cluster -y --cluster-name ${ROSA_CLUSTER_NAME} \
--region ${REGION} --version ${VERSION} \
--machine-cidr $CIDR \
--sts
rosa create operator-roles --cluster rosagitops --mode auto --yes
rosa create oidc-provider --cluster rosagitops
```

* Add cluster-admin user to the ROSA cluster:

```sh
rosa create admin --cluster=$ROSA_CLUSTER_NAME
```

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