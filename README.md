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
[tw4@tw4 ~]$ wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.22.1-1.el7.ngx.src.rpm
[tw4@tw4 ~]$ rpm -i nginx-1.22.1-1.el7.ngx.src.rpm
[tw4@tw4 ~]$ ll
total 1012
-rw-rw-r--. 1 tw4 tw4 1033399 Nov  6  2018 nginx-1.22.1-1.el7.ngx.src.rpm
drwxr-xr-x. 4 tw4 tw4      34 Nov 25 20:22 rpmbuild
```
Cкачиваем и разархивируем исходники openssl:

```bash
[tw4@tw4 ~]$ wget https://www.openssl.org/source/openssl-1.1.1s.tar.gz
[tw4@tw4 ~]$ tar -xf openssl-1.1.1s.tar.gz 
[tw4@tw4 ~]$ ll
total 10656
-rw-rw-r--.  1 tw4 tw4 1033399 Nov  6  2018 nginx-1.22.1-1.el7.ngx.src.rpm
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
[tw4@tw4 ~]$ rpmbuild -bb rpmbuild/SPECS/nginx.spec
[tw4@tw4 ~]$ ll rpmbuild/RPMS/x86_64/
total 4584
-rw-rw-r--. 1 tw4 tw4 2160996 Nov 25 20:52 nginx-1.22.1-1.el7.ngx.x86_64.rpm
-rw-rw-r--. 1 tw4 tw4 2528704 Nov 25 20:52 nginx-debuginfo-1.22.1-1.el7.ngx.x86_64.rpm
```

Проверим, работает ли наш пакет:

```bash
[tw4@tw4 ~]$ sudo yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.22.1-1.el7.ngx.x86_64.rpm 
...
Installed:
  nginx.x86_64 1:1.22.1-1.el7.ngx                                                    

Complete!
[tw4@tw4 ~]$ systemctl start nginx
[tw4@tw4 ~]$ systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Fri 2022-11-25 21:51:13 MSK; 7s ago
     Docs: http://nginx.org/en/docs/
  Process: 28951 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
```

## 2. создать свой репо и разместить там свой RPM

Cоздадим директорию для репозитория и скопируем туда rpm:

```bash
[tw4@tw4 ~]$ sudo mkdir /usr/share/nginx/html/repo
[tw4@tw4 ~]$ sudo cp rpmbuild/RPMS/x86_64/nginx-1.22.1-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/
[tw4@tw4 ~]$ sudo wget https://downloads.percona.com/downloads/percona-release/percona-release-1.0-9/redhat/percona-release-1.0-9.noarch.rpm -O /usr/share/nginx/html/percona-release-1.0-9.noarch.rpm 
```

Создаем репозиторий:

```bash
[tw4@tw4 ~]$ sudo createrepo /usr/share/nginx/html/repo/
Spawning worker 0 with 1 pkgs
Spawning worker 1 with 0 pkgs
Workers Finished
Saving Primary metadata
Saving file lists metadata
Saving other metadata
Generating sqlite DBs
Sqlite DBs completeыув 
```

## 3. реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо

