#!/bin/bash
set -e
sleep 15
yum update -y
yum -y install tree jq git htop lynx unzip wget
timedatectl set-timezone Asia/Seoul
echo "sudo su -" >> /home/ec2-user/.bashrc

# kubectl, helm, eksctl, aws cli 설치
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install

# AWS CLI 기본 리전 설정
mkdir -p /etc/aws
echo "[default]" > /etc/aws/config
echo "region = ${aws_region}" >> /etc/aws/config

# root 사용자를 위한 krew 설치
set -x
cd "$(mktemp -d)"
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64$/arm64/')"
KREW="krew-$${OS}_$${ARCH}"
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/$${KREW}.tar.gz"
tar zxvf "$${KREW}.tar.gz"
./"$${KREW}" install krew
set +x

# Docker 설치 및 ec2-user 권한 추가
yum install -y docker
systemctl start docker && systemctl enable docker
usermod -aG docker ec2-user

# root를 위한 SSH 키 생성
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa

# kubecolor 설치
wget https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz
tar -xzvf kubecolor_0.0.25_Linux_x86_64.tar.gz
mv kubecolor /usr/local/bin/

# --- [로그인 시 환경을 설정하는 최종 설정 블록 시작] ---
# /etc/profile.d/에 환경 설정 스크립트 생성
cat <<'EOF' > /etc/profile.d/eks-tools.sh
# Add /usr/local/bin for all users
export PATH=$PATH:/usr/local/bin

# Add krew path for root user
if [ "$USER" = "root" ]; then
    # 아래 라인의 KREW_ROOT 변수를 $$로 이스케이프 처리했습니다.
    export PATH="$${KREW_ROOT:-/root/.krew}/bin:$PATH"
fi

# Kubectl alias and completion for all users
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF

# root의 .bashrc에 kubecolor alias 추가
echo 'alias kubectl=kubecolor' >> /root/.bashrc

# krew 플러그인 설치 (root 권한으로)
export PATH="/root/.krew/bin:$PATH"
kubectl krew install ctx ns get-all

# CLUSTER_NAME 환경 변수 설정
echo "export CLUSTER_NAME=${cluster_base_name}" >> /etc/profile.d/eks-tools.sh
