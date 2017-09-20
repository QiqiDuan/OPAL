# 在centos 7操作系统上安装Spark集群

## Spark集群规模

一个主节点 + 三个从节点。所有计算节点都有着相同的硬件配置 [采用机架式服务器]，主要信息如下所示：

Spark版本：2.2.0 <<< ```http://spark.apache.org/```

操作系统版本：CentOS Linux release 7.3.1611 (Core) <<< ```cat /etc/redhat-release```

内存空间：64GB <<< ```free -h```

固态硬盘：1TB <<< ```df -h```

处理器：40  Intel(R) Xeon(R) CPU E5-2640 v4 @ 2.40GHz <<< ```cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c```

## 安装开发环境 [JAVA + Scala + Python + R]

### 安装JAVA JDK开发环境

```
查看CentOS 7操作系统默认安装的JAVA JDK软件版本，具体输出如下所示：
# java -version
openjdk version "1.8.0_131"
OpenJDK Runtime Environment (build 1.8.0_131-b12)
OpenJDK 64-Bit Server VM (build 25.131-b12, mixed mode)

删除CentOS 7操作系统默认安装的JAVA JDK软件版本：
# sudo yum -y remove java*

获取ORACLE公司提供的JAVA JDK软件版本：jdk-8u131-linux-x64.rpm。
注：以上的JAVA JDK软件版本会不断地进行更新，选择最新版即可：
# sudo yum install wget
# wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" 
  http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm?

安装JAVA JDK的RPM软件包：
# sudo yum localinstall jdk-8u131-linux-x64.rpm

验证JAVA JDK软件是否被成功安装，具体输出如下所示：
# java -version
java version "1.8.0_131"
Java(TM) SE Runtime Environment (build 1.8.0_131-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.131-b11, mixed mode)

查看JAVA JDK软件的实际安装位置：
# which java
# ls -l /usr/bin/java
# ls -l /etc/alternatives/java
# ls -l /usr/java/jdk1.8.0_131/jre/bin/java

如存在多个JAVA JDK软件版本，可能需要进行选择、配置：
# sudo alternatives --config java

特别注意：/usr/java/jdk1.8.0_131/bin/java与/usr/java/jdk1.8.0_131/jre/bin/java之间的区别，具体解释见参考资料。
配置JAVA JDK软件的系统环境变量，具体内容如下所示：
# sudo vi /etc/profile.d/java.sh
export JAVA_HOME=/usr/java/jdk1.8.0_131
export PATH=${JAVA_HOME}/bin:${PATH}

使得以上的系统环境变量即刻生效，并加以验证：
# . /etc/profile.d/java.sh
# echo $JAVA_HOME
# echo $PATH

查看JAVA JDK软件的实际安装位置，具体输出如下所示：
# which java
/usr/java/jdk1.8.0_131/bin/java
```

### 安装Scala语言开发环境

```
获取Scala-2.11.11的RPM安装包：
# wget https://downloads.lightbend.com/scala/2.11.11/scala-2.11.11.rpm

安装命令：
# sudo yum localinstall -y scala-2.11.11.rpm

查看安装是否成功，具体的输出如下所示：
# scala -version
Scala code runner version 2.11.11 -- Copyright 2002-2017, LAMP/EPFL

查看实际的安装位置：
# which scala
# ls -l /usr/bin/scala
# ls -l /usr/share/scala/bin/scala

配置Scala语言的系统环境变量，具体内容如下所示：
# sudo vi /etc/profile.d/scala.sh
export SCALA_HOME=/usr/share/scala
export PATH=${SCALA_HOME}/bin:${PATH}

使得以上的系统环境变量即刻生效，并加以验证：
# . /etc/profile.d/scala.sh
# echo $SCALA_HOME
# echo $PATH
```

### 安装Python语言开发环境

```
查看CentOS 7操作系统默认安装的Python软件版本：
# python -V
Python 2.7.5

查看Python软件具体的安装位置：
# which python
# ls -l /usr/bin/python
# ls -l /usr/bin/python2
# ls -l /usr/bin/python2.7

安装Python软件3.4版本：
# sudo yum install python34

安装Python软件3.4版本必要的开发工具：
# sudo yum install python34-setuptools
# sudo easy_install-3.4 pip
# sudo yum install python34-devel -y

升级pip版本，同时维持pip与pip3的方式有：
# pip -V
# sudo yum install python-pip
# pip -V
# pip3 -V

验证Python3.4版本是否安装成功：
# python3 --version
Python 3.4.5

基于Python软件3.4版本，安装Scrapy软件包：
# sudo yum install libffi-devel openssl-devel -y
# sudo pip3 install Scrapy

# python3
Python 3.4.5 (default, May 29 2017, 15:17:55)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-11)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import scrapy
>>> scrapy.__file__
'/usr/lib/python3.4/site-packages/scrapy/__init__.py'
```

虽然安装了Python3.4版本，但是建议使用Python2.7版本。

### 安装R语言开发环境

```
安装EPEL软件库：
# sudo yum install epel-release

更新EPEL软件库：
# sudo yum update

安装R语言：
# sudo yum install R -y

验证R语言开发环境是否被正确安装，具体输出如下所示：
# R --version
R version 3.4.0 (2017-04-21) -- "You Stupid Darkness"
Copyright (C) 2017 The R Foundation for Statistical Computing
Platform: x86_64-redhat-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
http://www.gnu.org/licenses/.
```

## 基于standalone集群模式

### 用户与文件管理

```
为spark集群创建用户，所有节点需要使用相同的用户名（否则可能导致集群无法开启）:
# sudo useradd sk
# sudo passwd sk
注：可采用群组方式，组织管理用户。

在用户sk的主目录下创建spark主文件夹：
# mkdir sparkdir
# cd sparkdir/
# tar -zxvf spark-2.2.0-bin-hadoop2.7.tgz # 建议直接从Spark官网下载
# mv spark-2.2.0-bin-hadoop2.7 standalone
```

### 网络端口与防火墙管理

```
开通主节点（master）的网络端口：4040（Spark context Web UI）、6066（cluster mode）、7077（master）、8080（WEB UI）：
# sudo firewall-cmd --zone=public --add-port=4040/tcp --permanent
# sudo firewall-cmd --zone=public --add-port=6066/tcp --permanent
# sudo firewall-cmd --zone=public --add-port=7077/tcp --permanent
# sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
# sudo firewall-cmd --reload
# sudo firewall-cmd --zone=public --list-all

开通从节点（slave）的网络端口：8081（WEB UI）：
# sudo firewall-cmd --zone=public --add-port=8081/tcp --permanent
# sudo firewall-cmd --reload
# sudo firewall-cmd --zone=public --list-all

可在WINDOWS上，利用telnet验证各网络端口是否被正确开启（但未必总是有效）：
# telnet IP PORT

关闭防火墙，防止```Initial job has not accepted any resources```错误产生：
# sudo systemctl stop firewalld.service
# sudo systemctl disable firewalld.service

关闭SELINUX：
# sudo setenforce 0
# sudo vi /etc/selinux/config
SELINUX=disabled
```

### 手动开启模式

```
人工开启主节点：
# cd standalone
# ./sbin/start-master.sh

人工开启从节点：
# cd standalone
# ./sbin/start-slave.sh spark://IP:PORT

打开主节点WEB UI进行监控，网址为：MASTER-IP:PORT
```

### 脚本运行模式

```
绑定主机名与对应IP [应涵盖所有计算节点]：
# sudo vi /etc/hosts

主节点免密登录设置：
# ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
# cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# cat ~/.ssh/authorized_keys

从节点免密登录设置：
# ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
# cat ~/.ssh/id_rsa.pub # 复制此内容添加到主节点文件~/.ssh/authorized_keys

将主节点免密登录认证复制到从节点：
# chmod 600 ~/.ssh/authorized_keys
# scp ~/.ssh/authorized_keys sk@slave-ip:/home/sk/.ssh/authorized_keys

验证免密登录是否成功 [共12次]：
# ssh sk@IP
# exit

Spark配置文件设置：
# cd conf/
# cp slaves.template slaves
# vi slaves # 添加从节点hostname
# scp ~/sparkdir/standalone/conf/slaves sk@slave-ip:/home/sk/sparkdir/standalone/conf/slaves
# scp ~/sparkdir/standalone/conf/slaves sk@slave-ip:/home/sk/sparkdir/standalone/conf/slaves
# scp ~/sparkdir/standalone/conf/slaves sk@slave-ip:/home/sk/sparkdir/standalone/conf/slaves

Spark集群开启与关闭：
# ./sbin/start-all.sh # 开启所有的计算节点
# ./bin/spark-shell --master spark://master-ip:7077 # 查看主节点 Web UI，惊喜！
# ./sbin/stop-all.sh # 关闭所有的计算节点
```

## 安装sbt开发环境与breeze线性代数包

```sbt```的安装命令，如下所示：

```
# curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
# sudo yum install sbt
# sbt # 可能耗费较长时间；建议先建立sbt项目工作空间sbtProj，再在工作空间中运行此命令
# sbt sbtVersion
[info] 1.0.1
```

配置```build.sbt```，导入```breeze```线性代数包：

```
# vi build.sbt
libraryDependencies += "org.scalanlp" % "breeze_2.11" % "0.12"

resolvers += "Sonatype Releases" at "https://oss.sonatype.org/content/repositories/releases/"

scalaVersion := "2.11.11"
```

```
> console
scala > import breeze.linalg._
scala > import breeze.numerics._
```

## 参考资料

[Spark官网](http://spark.apache.org/docs/latest/spark-standalone.html)

[Java SE Development Kit 8官方下载网址](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

[/usr/java/jdk1.8.0_131/bin/java与/usr/java/jdk1.8.0_131/jre/bin/java之间的区别](https://unix.stackexchange.com/questions/134985/whats-the-difference-between-java-located-inside-jdk-bin-and-jdk-jre-bin)

[Scala语言官网](https://www.scala-lang.org/download/install.html)

[Python语言官网](https://www.python.org/)

[Pip软件包安装官方指南](https://packaging.python.org/guides/installing-using-linux-tools/)

[Scrapy软件包安装问题解决方案](https://stackoverflow.com/questions/22073516/failed-to-install-python-cryptography-package-with-pip-and-setup-py)

[R语言官网](https://cran.r-project.org/index.html)

[EPEL官网](https://fedoraproject.org/wiki/EPEL)

[R语言RPM安装包中科大镜像网站](https://mirrors.ustc.edu.cn/epel/7/x86_64/r/)

[sbt官网](http://www.scala-sbt.org/index.html)

[breeze代码库](https://github.com/scalanlp/breeze)

## 文档信息

```
Authors: Qiqi Duan [11749325@mail.sustc.edu.cn]
         Lijun Sun
Version: v00.00.000 [2017-09-11 21:30:00]
         v00.00.001 [2017-09-19 19:30:00]
         v00.00.002 [2017-09-20 20:00:00]
```
