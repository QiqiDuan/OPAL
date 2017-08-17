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
