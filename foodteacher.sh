git clone https://github.com/gracepark0120/foodteacher-helm.git
cd foodteacher-helm


# argocd
curl -LO https://github.com/argoproj/argo-cd/releases/download/v1.4.2/argocd-linux-amd64
chmod u+x argocd-linux-amd64
sudo mv argocd-linux-amd64 /usr/local/bin/argocd
export PATH=/usr/local/bin:$PATH
echo 'export PATH=/usr/local/bin:$PATH' >> ~/.bashrc

kubectl create namespace argocd
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n argocd

kubectl create clusterrolebinding default-admin --clusterrole=admin --serviceaccount=argocd:default

mkdir /mnt/db
tar -xvf mysql_backup.tar.gz
mv mnt/* /mnt
rm mnt -r

# ingress
minikube addons enable ingress

# cert-manager
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.0/cert-manager.yaml

# monitoring grafana, prometheus
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.1/components.yaml

#metric server deployment 의 스펙에 kubelet-insecure-tls 문구 추가해야됨
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring


