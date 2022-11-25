# Домашнее задание: размещаем свой RPM в своем репозитории.

1. создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями);
2. создать свой репо и разместить там свой RPM;
3. реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо.

#Выполнение

## 1. создать свой RPM

Устанавливаем необходимые пакеты дял успешного выполнения задания:

```bash
[tw4@tw4 ~]$ sudo yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
```

Cкачиваем source пакет nginx и устанавливаем его в домашней директории:

```bash
[tw4@tw4 ~]$ wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
[tw4@tw4 ~]$ rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
[tw4@tw4 ~]$ ll
total 1012
-rw-rw-r--. 1 tw4 tw4 1033399 Nov  6  2018 nginx-1.14.1-1.el7_4.ngx.src.rpm
drwxr-xr-x. 4 tw4 tw4      34 Nov 25 20:22 rpmbuild
```
Cкачиваем и разархивируем исходники openssl:

```bash
[tw4@tw4 ~]$ wget https://www.openssl.org/source/openssl-1.1.1s.tar.gz
[tw4@tw4 ~]$ tar -xf openssl-1.1.1s.tar.gz 
[tw4@tw4 ~]$ ll
total 10656
-rw-rw-r--.  1 tw4 tw4 1033399 Nov  6  2018 nginx-1.14.1-1.el7_4.ngx.src.rpm
drwxrwxr-x. 19 tw4 tw4    4096 Nov  1 15:36 openssl-1.1.1s
-rw-rw-r--.  1 tw4 tw4 9868981 Nov  1 18:36 openssl-1.1.1s.tar.gz
drwxr-xr-x.  4 tw4 tw4      34 Nov 25 20:22 rpmbuild
```

Устанавливаем зависимости:

```bash
[tw4@tw4 ~]$ sudo yum-builddep rpmbuild/SPECS/nginx.spec
```

Вносим изменения в scpecfile nginx:

```bash
sed -i 's@--with-ld-opt="%{WITH_LD_OPT}" @--with-ld-opt="%{WITH_LD_OPT}" \\\n    --with-openssl=/home/tw4/openssl-1.1.1s @g' rpmbuild/SPECS/nginx.spec
```

Собираем пакет:

```bash
rpmbuild -bb rpmbuild/SPECS/nginx.spec




## 2. создать свой репо и разместить там свой RPM
## 3. реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо

