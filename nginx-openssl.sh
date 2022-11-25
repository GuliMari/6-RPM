#!/bin/bash

# устанавливаем необходимые пакеты дял успешного выполнения задания
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
exit

# скачиваем source пакет nginx и устанавливаем его в домашней директории
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

# скачиваем и разархивируем исходники openssl
wget https://www.openssl.org/source/openssl-1.1.1s.tar.gz
tar -xf openssl-1.1.1s.tar.gz 

# устанавливаем зависимости
yum-builddep rpmbuild/SPECS/nginx.spec 

# вносим изменения в scpecfile nginx
sed -i 's@--with-ld-opt="%{WITH_LD_OPT}" @--with-ld-opt="%{WITH_LD_OPT}" \\\n    --with-openssl=/root/openssl-1.1.1s @g' /root/rpmbuild/SPECS/nginx.spec

# собираем rpm пакет
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec
