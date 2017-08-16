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

更多的操作系统本地化设置说明与细节，可参考 >>

[Chapter 1. System Locale and Keyboard Configuration, Red Hat Enterprise Linux 7 System Administrator's Guide](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/pdf/System_Administrators_Guide/Red_Hat_Enterprise_Linux-7-System_Administrators_Guide-en-US.pdf)
