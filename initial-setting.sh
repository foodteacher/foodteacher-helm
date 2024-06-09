#!/bin/sh
sudo apt-get update
sudo apt-get install -y socat

# crictl
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz

tar -xvf crictl-v1.28.0-linux-amd64.tar.gz
sudo mv crictl /usr/local/bin/
sudo chmod +x /usr/local/bin/crictl

# docker
sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release

# 도커의 공식 GPG key를 추가합니다.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# apt 패키지 매니저로 도커를 설치할 때, stable Repository에서 받아오도록 설정합니다.
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y containerd.io docker-ce=5:20.10.11~3-0~ubuntu-focal docker-ce-cli=5:20.10.11~3-0~ubuntu-focal docker-buildx-plugin docker-compose-plugin
sudo apt autoremove -y

# 도커 권한 설정
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# 현재 폴더에 kubectl v1.29.0 버전 다운
curl -LO https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl

# 파일 권한, 위치 변경
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# minikube 
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

sudo apt update
sudo apt install conntrack

# k9s
wget https://github.com/derailed/k9s/releases/download/v0.32.4/k9s_Linux_amd64.tar.gz
tar -zxvf ./k9s_Linux_amd64.tar.gz
sudo mv ./k9s ~/.local/bin && chmod +x ~/.local/bin/k9s
echo "export PATH=$PATH:$HOME/.local/bin" >> ~/.bashrc
source ~/.bashrc

# minikube start
sudo su
minikube start --driver=none \
	--kubernetes-version=v1.29.0 \
  --extra-config=apiserver.service-account-signing-key-file=/var/lib/minikube/certs/sa.key \
  --extra-config=apiserver.service-account-issuer=kubernetes.default.svc

