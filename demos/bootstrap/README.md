### Bootstrap GitOps Demo Environment

* Create Kind Cluster for GitOps Demo:

```sh
CLUSTER_NAME="gitops"
cat <<EOF | kind create cluster --name $CLUSTER_NAME --wait 200s --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF

kubectl cluster-info --context kind-gitops
```

* Deploy Ingress Nginx Controller: 

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

sleep 30
kubectl get pod -n ingress-nginx
```

* Test Ingress Nginx Controller with an small test app:

```sh
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml

sleep 10
curl localhost/foo
curl localhost/bar
```

* Deploy ArgoCD community:

```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 60
kubectl get pod -n argocd
```

* Setup a patch for the Ingress for ArgoCD:

```sh
kubectl -n ingress-nginx patch deployment ingress-nginx-controller -p '{"spec":{"template":{"spec":{"$setElementOrder/containers":[{"name":"controller"}],"containers":[{"args":["/nginx-ingress-controller","--election-id=ingress-controller-leader","--ingress-class=nginx","--configmap=ingress-nginx/ingress-nginx-controller","--validating-webhook=:8443","--validating-webhook-certificate=/usr/local/certificates/cert","--validating-webhook-key=/usr/local/certificates/key","--publish-status-address=localhost","--enable-ssl-passthrough"],"name":"controller"}]}}}}'
```

* Setup a patch for the Ingress for ArgoCD:

```
ARGO_URL="argocd.rcarrata.com"

cat <<EOF | kubectl -n argocd apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
spec:
  rules:
  - host: ${ARGO_URL}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              name: https
EOF
````

* Open the Firewall for access the ArgoCD instance

```sh
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=8443/tcp --permanent
```

* Login to the cluster using ssh -L or with the IP and dns:

```sh
ssh -L 8443:localhost:443 -L 8080:localhost:80 osiris

cat /etc/hosts | grep argo
127.0.0.1 argocd.rober.lab
xxx argocd.rober.lab
```

* Get the ArgoCD admin password:

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

* Install the ArgoCD cli:

```sh
wget https://github.com/argoproj/argo-cd/releases/download/v2.6.2/argocd-linux-amd64
ll
chmod u+x argocd-linux-amd64
mv argocd-linux-amd64 /usr/local/bin/argocd
argocd
```

* Login with argoCD tooling:

```sh
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
argocd login --insecure --grpc-web argocd.rober.lab --username admin --password $argoPass
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
```

* Test a simple app if it's all working properly:

```
cat <<EOF | kubectl -n argocd apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kustomize-guestbook
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: kustomize-guestbook
    server: https://kubernetes.default.svc
  project: default
  source:
    path: kustomize-guestbook
    repoURL: https://github.com/argoproj/argocd-example-apps
    targetRevision: HEAD
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF
```


