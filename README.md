## ToDo
- [x] ~eks용 vpc 구성~
- [x] ~Bastion 서버<ec2 인스턴스> 생성 (kubectl과 helm, docker가 설치되어 있으며 eks 워커노드 제어 가능)~
- [x] ~iam role 생성 (eks 클러스터 및 노드 정책 적용)~
- [x] ~eks 클러스터 생성~
- [x] ~eks 노드그룹 생성~

## 간단 사용법

### 테라폼 사용법
```bash

terraform init

terraform fmt

terraform validate

terraform plan

# 하면 key-pair 물어보는데, aws에 미리 생성한 키 이름을 그대로 치면 됩니다.
terraform apply

terraform destroy

```

### 인프라 구축(클러스터 생성) 후 해야할 것.
1. bastion서버로 접속할 것 (점프서버가 아니라 호스트에서 제어하고싶다면, 호스트에 kubectl, helm 설치할 것.)
2. bastion 서버에서 aws configure 설정 (호스트역시 aws configure 설정).
3. bastion 서버에서 다음 명령어를 사용하여 eks 클러스터의 kube-config 파일 설정값을 불러올 것 (호스트역시 똑같이 설정).
```bash
aws eks --region ap-northeast-2 update-kubeconfig --name my-eks
``` 

## How To Test
```bash
helm repo add ptj-miniproject https://gedflow.github.io/k8s_prac/

helm install <별칭> ptj-miniproject/flaskDiary

kubectl get all -o wide
```
서비스 부분을 보면 LoadBalancer가 존재한다.  
EXTERNAL-IP를 보면 AWS의 클래식 로드밸런서의 엔드포인트가 표시된다.  
해당 주소로 브라우저에서 접속하면 테스트 가능.  