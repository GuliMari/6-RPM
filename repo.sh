#!/bin/bash

sudo -i
cd /root

yum update -y
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc

wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.22.1-1.el7.ngx.src.rpm
rpm -i nginx-1.22.1-1.el7.ngx.src.rpm

wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1s.tar.gz
tar -xf openssl-1.1.1s.tar.gz

yum-builddep -y rpmbuild/SPECS/nginx.spec
sed -i 's@--with-ld-opt="%{WITH_LD_OPT}" @--with-ld-opt="%{WITH_LD_OPT}" \\\n    --with-openssl=/root/openssl-1.1.1s @g' rpmbuild/SPECS/nginx.spec
rpmbuild -bb rpmbuild/SPECS/nginx.spec

yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.22.1-1.el7.ngx.x86_64.rpm 
systemctl enable --now nginx

mkdir /usr/share/nginx/html/repo
cp rpmbuild/RPMS/x86_64/nginx-1.22.1-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget https://downloads.percona.com/downloads/percona-release/percona-release-1.0-9/redhat/percona-release-1.0-9.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-9.noarch.rpm 

createrepo /usr/share/nginx/html/repo/

sed -i 's@        index  index.html index.htm;@        index  index.html index.htm;\n        autoindex on;@' /etc/nginx/conf.d/default.conf
nginx -s reload

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
