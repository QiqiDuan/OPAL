# CentOS 7操作系统 - 系统管理指南

## 操作系统本地化设置

```
三个基本的操作系统本地化设置 [操作系统语言、终端(console)键盘语言、X11图形界面(GUI)键盘语言]
# localectl status
   System Locale: LANG=en_US.UTF-8
       VC Keymap: us
      X11 Layout: us

操作系统语言本地化设置
# echo $LANG
en_US.UTF-8

操作系统语言本地化选项 [以中文为例]
# localectl list-locales | grep zh_CN
zh_CN
zh_CN.gb18030
zh_CN.gb2312
zh_CN.gbk
zh_CN.utf8

键盘本地化选项 [以中文为例]
# localectl list-keymaps | grep cn
cn
```

更多的操作系统本地化设置说明与细节，可参考 >>>

[Chapter 1. System Locale and Keyboard Configuration, Red Hat Enterprise Linux 7 System Administrator's Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/pdf/System_Administrators_Guide/Red_Hat_Enterprise_Linux-7-System_Administrators_Guide-en-US.pdf)

## 配置系统时间

```timedatectl```：是```systemd```系统的一部分 [software clock, system clock]。

```date```：最基本的系统时间管理工具。

```hwclock```：硬件时间管理工具 [hardware clock, real-time clock]。

UTC（Coordinated Universal Time）：协调世界时。

CST：China Standard Time UT+8:00（中国标准时间）、Central Standard Time (USA) UT-6:00（美国中部时间）等。

```
安装NTP [网络时间协议]，Network Time Protocol官方网址：http://www.ntp.org/
# yum -y install ntp ntpdate

更新系统时间，使其与UTC时间同步
# ntpdate cn.pool.ntp.org

将系统时间写入硬件时间
# hwclock --systohc

# date
# date -u # date --utc
# date +"%Y-%m-%d %H:%M:%S"

显示可用的时区选项 [以中国上海为例]
# timedatectl list-timezones | grep Shanghai
```

更多的系统时间配置说明与细节，可参考 >>>

[Chapter 2. Configuring the Date and Time, Red Hat Enterprise Linux 7 System Administrator's Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/pdf/System_Administrators_Guide/Red_Hat_Enterprise_Linux-7-System_Administrators_Guide-en-US.pdf)

## 系统用户管理

超级用户：root。SHELL提示符以```#```开头。

系统管理员：system administration、sysadmin、admin。

用户标识：userid、User ID、UID、user identification。习惯上，UID仅使用小写字母表示。SHELL提示符以```$```开头。

群组：Group ID、GID。在一个群组内的所有用户，共享该群组所拥有的读、写、执行权限。

```
查看基本的用户信息
# id

添加用户到wheel用户组中
# usermod -aG wheel *user-name* # supplementary groups

新增用户，并在home目录下创建用户文件夹
# adduser *user-name*
对比：在Ubuntu 16.04操作系统下，在home目录下创建用户文件夹

新增用户，并在home目录下创建用户文件夹
# useradd *user-name*
对比：在Ubuntu 16.04操作系统下，不在home目录下创建用户文件夹

为用户设置密码，useradd会锁定用户账号，通过passwd解锁
# passwd *user-name*

修改密码
# passwd

删除用户
# userdel -r *user-name*

切换到其他用户
# su - *another-user-name*

创建用户后，会自动更新的配置文件主要有：
/etc/passwd
/etc/shadow
/etc/group
/etc/gshadow

创建用户后，会自动将默认配置文件复制到该用户的主目录下
# cd /etc/skel/ | ls -al
.bash_logout
.bash_profile
.bashrc

# ls -al /home/*user-name*
.bash_logout
.bash_profile
.bashrc

创建群组
# groupadd *group-name*
# cat /etc/group

创建群组共享目录
# mkdir *share-folder* # 绝对路径
# groupadd *group-name*
# chown *user-name*:*group-name* *share-folder*
# usermod -aG *group-name* *user-name*
# chmod 2775 *share-folder*
# ls -ld *share-folder*
d rwx rws r-x
# usermod -aG *group-name* *another-user-name*

设置新建文件默认权限；处于安全原因，默认情况下常规文件没有执行权限；而文件夹拥有执行权限
0表示?
1表示没有执行权限
2表示没有写权限 [3表示没有写、执行权限]
4表示没有读权限 [7表示没有读、写、执行权限]
# umask
0002
# umask -S
u=rwx,g=rwx,o=rx

查看用户最近登录记录 [包含重启]
# last *user-name*
# who
# whoami
# who am i
# users
# w *user-name*

退出系统、关闭SHELL
# logout
# exit
# CTRL-D
```

更多的系统用户管理说明与细节，可参考 >>>

[Chapter 3. Managing Users and Groups, Red Hat Enterprise Linux 7 System Administrator's Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/pdf/System_Administrators_Guide/Red_Hat_Enterprise_Linux-7-System_Administrators_Guide-en-US.pdf)
