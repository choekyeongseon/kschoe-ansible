#!/bin/sh

# $1  #project domain, example: seoul-city.com

if [ $# -ne 1 ] ; then
    echo "Please check typing project domain information"	
    echo "Usage: ./create_utilcerts.sh {{ project_domain }}"
    exit 0
fi

HARBOR_DIR=$PWD/harbor
BOOTSTRAP_REGISTRY_DIR=$PWD/bootstrap-registry
SERVICE_REGISTRY_DIR=$PWD/service-registry
GITLAB_DIR=$PWD/gitlab
CHARTMUSEUM_DIR=$PWD/chartmuseum


echo "creating working directories..... $HARBOR_DIR, $BOOTSTRAP_REGISTRY_DIR, $SERVICE_REGISTRY_DIR, $GITLAB_DIR $CHARTMUSEUM_DIR"
mkdir -p $HARBOR_DIR $BOOTSTRAP_REGISTRY_DIR $SERVICE_REGISTRY_DIR $GITLAB_DIR $CHARTMUSEUM_DIR

######################################################################
############################### Harbor ###############################
######################################################################
echo "\n######################### [START] Harbor #########################"
echo "creating Harbor cert files..."

export DOMAIN=harbor.$1
echo "Harbor Domain is $Domain"

# CA ������ ����
openssl genrsa -out $HARBOR_DIR/ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 -subj '/C=KR/ST=Seoul/CN=RootCA' -key $HARBOR_DIR/ca.key -out $HARBOR_DIR/ca.crt

# ����Ű ����
openssl genrsa -out $HARBOR_DIR/$DOMAIN.key 4096
openssl req -sha512 -new -subj "/C=KR/ST=Seoul/L=Jung-gu/O=Innogrid/OU=IT/CN=$DOMAIN" -key $HARBOR_DIR/$DOMAIN.key -out $HARBOR_DIR/$DOMAIN.csr

# x509 v3 Ȯ�� ���� ����
touch $HARBOR_DIR/v3.ext
cat <<EOF | sudo tee $HARBOR_DIR/v3.ext
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN
DNS.2=$1
EOF

# CA �������� ȣ��Ʈ�� ���� ������ ����
openssl x509 -req -sha512 -days 365000 -extfile $HARBOR_DIR/v3.ext -CA $HARBOR_DIR/ca.crt -CAkey $HARBOR_DIR/ca.key -CAcreateserial -in $HARBOR_DIR/$DOMAIN.csr -out $HARBOR_DIR/$DOMAIN.crt

echo "\ncompleted: creating Harbor cert files. check: ls -al $BOOTSTRAP_REGISTRY_DIR"
echo "######################### [END] Harbor #########################"

######################################################################
######################### BootStrap-Registry #########################
######################################################################

echo "\n######################### [START] BootStrap-Registry #########################"
echo "creating Bootstrap-Registry cert files..."

export DOMAIN=secloudit-bootstrap-registry.$1
echo "Bootstrap-Registry Domain is $DOMAIN"

# CA ������ ����
openssl genrsa -out $BOOTSTRAP_REGISTRY_DIR/ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 -subj '/C=KR/ST=Seoul/CN=RootCA' -key $BOOTSTRAP_REGISTRY_DIR/ca.key -out $BOOTSTRAP_REGISTRY_DIR/ca.crt

# ����Ű ����
openssl genrsa -out $BOOTSTRAP_REGISTRY_DIR/$DOMAIN.key 4096
openssl req -sha512 -new -subj "/C=KR/ST=Seoul/L=Jung-gu/O=Innogrid/OU=IT/CN=$DOMAIN" -key $BOOTSTRAP_REGISTRY_DIR/$DOMAIN.key -out $BOOTSTRAP_REGISTRY_DIR/$DOMAIN.csr

# x509 v3 Ȯ�� ���� ����
touch $BOOTSTRAP_REGISTRY_DIR/v3.ext
cat <<EOF | sudo tee $BOOTSTRAP_REGISTRY_DIR/v3.ext
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN
DNS.2=$1
EOF

# CA �������� ȣ��Ʈ�� ���� ������ ����
openssl x509 -req -sha512 -days 365000 -extfile $BOOTSTRAP_REGISTRY_DIR/v3.ext -CA $BOOTSTRAP_REGISTRY_DIR/ca.crt -CAkey $BOOTSTRAP_REGISTRY_DIR/ca.key -CAcreateserial -in $BOOTSTRAP_REGISTRY_DIR/$DOMAIN.csr -out $BOOTSTRAP_REGISTRY_DIR/$DOMAIN.crt

echo "\ncompleted: creating Bootstrap-Registry cert files. check: ls -al $BOOTSTRAP_REGISTRY_DIR"
echo "######################### [END] BootStrap-Registry #########################"

####################################################################
######################### Service-Registry #########################
####################################################################

echo "\n######################### [START] Service-Registry #########################"
echo "creating Service-Registry cert files..."

export DOMAIN=secloudit-service-registry.$1
echo "Service-Registry Domain is $DOMAIN"

# CA ������ ����
openssl genrsa -out $SERVICE_REGISTRY_DIR/ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 -subj '/C=KR/ST=Seoul/CN=RootCA' -key $SERVICE_REGISTRY_DIR/ca.key -out $SERVICE_REGISTRY_DIR/ca.crt

# ����Ű ����
openssl genrsa -out $SERVICE_REGISTRY_DIR/$DOMAIN.key 4096
openssl req -sha512 -new -subj "/C=KR/ST=Seoul/L=Jung-gu/O=Innogrid/OU=IT/CN=$DOMAIN" -key $SERVICE_REGISTRY_DIR/$DOMAIN.key -out $SERVICE_REGISTRY_DIR/$DOMAIN.csr

# x509 v3 Ȯ�� ���� ����
touch $SERVICE_REGISTRY_DIR/v3.ext
cat <<EOF | sudo tee $SERVICE_REGISTRY_DIR/v3.ext
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN
DNS.2=$1
EOF

# CA �������� ȣ��Ʈ�� ���� ������ ����
openssl x509 -req -sha512 -days 365000 -extfile $SERVICE_REGISTRY_DIR/v3.ext -CA $SERVICE_REGISTRY_DIR/ca.crt -CAkey $SERVICE_REGISTRY_DIR/ca.key -CAcreateserial -in $SERVICE_REGISTRY_DIR/$DOMAIN.csr -out $SERVICE_REGISTRY_DIR/$DOMAIN.crt

echo "completed: creating Service-Registry cert files. check: ls -al $SERVICE_REGISTRY_DIR"
echo "######################### [END] Service-Registry #########################"

####################################################################
############################## Gitlab ##############################
####################################################################

echo "\n######################### [START] Gitlab #########################"
echo "creating Gitlab cert files..."

export DOMAIN=gitlab.$1
echo "Gitlab Domain is $DOMAIN"

# CA ������ ����
openssl genrsa -out $GITLAB_DIR/ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 -subj '/C=KR/ST=Seoul/CN=RootCA' -key $GITLAB_DIR/ca.key -out $GITLAB_DIR/ca.crt

# ����Ű ����
openssl genrsa -out $GITLAB_DIR/$DOMAIN.key 4096
openssl req -sha512 -new -subj "/C=KR/ST=Seoul/L=Jung-gu/O=Innogrid/OU=IT/CN=$DOMAIN" -key $GITLAB_DIR/$DOMAIN.key -out $GITLAB_DIR/$DOMAIN.csr

# x509 v3 Ȯ�� ���� ����
touch $GITLAB_DIR/v3.ext
cat <<EOF | sudo tee $GITLAB_DIR/v3.ext
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN
DNS.2=$1
EOF

# CA �������� ȣ��Ʈ�� ���� ������ ����
openssl x509 -req -sha512 -days 365000 -extfile $GITLAB_DIR/v3.ext -CA $GITLAB_DIR/ca.crt -CAkey $GITLAB_DIR/ca.key -CAcreateserial -in $GITLAB_DIR/$DOMAIN.csr -out $GITLAB_DIR/$DOMAIN.crt

echo "completed: creating Gitlab cert files. check: ls -al $GITLAB_DIR"
echo "######################### [END] Gitlab #########################"

####################################################################
######################### Helm ChartMuseum #########################
####################################################################

echo "\n######################### [START] ChartMuseum #########################"
echo "creating ChartMuseum cert files..."

export DOMAIN=chartmuseum.$1
echo "ChartMuseum Domain is $DOMAIN"

# CA ������ ����
openssl genrsa -out $CHARTMUSEUM_DIR/ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 -subj '/C=KR/ST=Seoul/CN=RootCA' -key $CHARTMUSEUM_DIR/ca.key -out $CHARTMUSEUM_DIR/ca.crt

# ����Ű ����
openssl genrsa -out $CHARTMUSEUM_DIR/$DOMAIN.key 4096
openssl req -sha512 -new -subj "/C=KR/ST=Seoul/L=Jung-gu/O=Innogrid/OU=IT/CN=$DOMAIN" -key $CHARTMUSEUM_DIR/$DOMAIN.key -out $CHARTMUSEUM_DIR/$DOMAIN.csr

# x509 v3 Ȯ�� ���� ����
touch $CHARTMUSEUM_DIR/v3.ext
cat <<EOF | sudo tee $CHARTMUSEUM_DIR/v3.ext
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=$DOMAIN
DNS.2=$1
EOF

# CA �������� ȣ��Ʈ�� ���� ������ ����
openssl x509 -req -sha512 -days 365000 -extfile $CHARTMUSEUM_DIR/v3.ext -CA $CHARTMUSEUM_DIR/ca.crt -CAkey $CHARTMUSEUM_DIR/ca.key -CAcreateserial -in $CHARTMUSEUM_DIR/$DOMAIN.csr -out $CHARTMUSEUM_DIR/$DOMAIN.crt


echo "completed: creating ChartMuseum cert files. check: ls -al $CHARTMUSEUM_DIR"
echo "######################### [END] Chartmuseum #########################"
