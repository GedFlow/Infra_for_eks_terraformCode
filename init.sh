#!/bin/bash

# elasticsearch PGP key 다운
sudo apt update && sudo apt install -y apt-transport-https wget gnupg
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

# elasticsearch 설치
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/9.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-9.x.list
sudo apt-get update && sudo apt-get install elasticsearch

# kibana 설치
sudo apt-get install kibana

# 이후 구성은 수동

# elasticserach의 네트워크 구성 파일 (설치 후에 생성되며, sudo 권한이 필요하다)
# /etc/elasticsearch/elasticsearch.yml

# 아래 명령어로 비밀번호 초기화 가능
# sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic

# kibana의 구성 파일 (설치 후에 생성되며, sudo 권한이 필요하다)
# /etc/kibana/kibana.yml