# Linux工具

## 一键重装ubuntu

### 16.04

```bash
curl -L http://docs.droid.ac.cn/rocdocs/scripts/reinstall_ubuntu1604.sh | bash
```



### 18.04

```bash
curl -L http://docs.droid.ac.cn/rocdocs/scripts/reinstall_ubuntu1804.sh | bash
```



包含软件：

- vim
- git
- ssh
- htop
- tmux
- tree
- terminator
- indicator-sysmonitor
- chrome
- sublimetext
- typora
- vscode
- ros-melodic-desktop-full
- qtcreator-ros
- rosdep
- systemback
- ssh-keygen
- catkin_ws
- xbot ROS repo
- xbot dependency ROS packages
- catkin_make





## 硬盘开机自动挂载

### 查看已接入的存储设备

```
lsblk
```

### 用户手动挂载

```
sudo mkdir /mnt/udisk
sudo mount /dev/sdb /mnt/udisk
```

### 用户手动取消挂载

```
sudo umount /dev/sdb
```

### 设置开机自动挂载

第一步：查看挂载硬盘的UUID

```
sudo blkid /dev/sdb
```

返回信息为

```
/dev/sdb: LABEL="Data" UUID="88069947069936E2" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="7170f9a7-9c9f-43d8-9916-da47aa9101f7"
```

则能够从返回信息中获取UUID=”88069947069936E2”.

第二步：修改自动挂载配置文件

编辑/etc/fstab

在文件末尾添加需要挂载的硬盘信息

```
UUID=88069947069936E2 /mnt/udisk ntfs defaults  0  2
```

第一个数字：0表示开机不检查磁盘，1表示开机检查磁盘；
第二个数字：0表示交换分区，1代表启动分区（Linux），2表示普通分区
我挂载的分区是在WIn系统下创建的分区，磁盘格式为ntfs，若是在linux下创建的分区，磁盘格式一般为ext4。

重启即可看到已成功挂载的硬盘了。

## Ubuntu删除多余的内核

### 第一步：查看当前内核

```ruby
rew $ uname -a
Linux rew 4.15.0-42-generic #45~16.04.1-Ubuntu SMP Mon Nov 19 13:02:27 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```

当前使用版本为：`4.15.0-42-generic`

### 第二步：查看所有内核

```csharp
rew $ dpkg --get-selections | grep linux
console-setup-linux                     install
libselinux1:amd64                       install
libselinux1:i386                        install
linux-base                              install
linux-firmware                          install
linux-generic-hwe-16.04                 install
linux-headers-4.15.0-42                 install
linux-headers-4.15.0-39                 install
linux-headers-4.15.0-39-generic         install
linux-headers-4.15.0-42-generic         install
linux-headers-generic-hwe-16.04         install
linux-image-4.15.0-39-generic           install
linux-image-4.15.0-42-generic           install
linux-image-generic-hwe-16.04           install
linux-libc-dev:amd64                    install
linux-libc-dev:i386                     install
linux-modules-4.15.0-39-generic         install
linux-modules-4.15.0-42-generic         install
linux-modules-extra-4.15.0-39-generic   install
linux-modules-extra-4.15.0-42-generic   install
linux-sound-base                        install
pptp-linux                              install
syslinux                                install
syslinux-common                         install
syslinux-legacy                         install
util-linux                              install
```

### 第三步：移除冗余内核

 所有`39`版本的对我来说都是多余的，进行删除：

```csharp
rew $ sudo apt-get remove \
linux-headers-4.15.0-39 \
linux-headers-4.15.0-39-generic \
linux-image-4.15.0-39-generic \
linux-modules-4.15.0-39-generic \
linux-modules-extra-4.15.0-39-generic
```

卸载后重新检查：

```csharp
rew $ dpkg --get-selections | grep linux
console-setup-linux                     install
libselinux1:amd64                       install
libselinux1:i386                        install
linux-base                              install
linux-firmware                          install
linux-generic-hwe-16.04                 install
linux-headers-4.15.0-42                 install
linux-headers-4.15.0-42-generic         install
linux-headers-generic-hwe-16.04         install
linux-image-4.15.0-39-generic           deinstall
linux-image-4.15.0-42-generic           install
linux-image-generic-hwe-16.04           install
linux-libc-dev:amd64                    install
linux-libc-dev:i386                     install
linux-modules-4.15.0-39-generic         deinstall
linux-modules-4.15.0-42-generic         install
linux-modules-extra-4.15.0-39-generic   deinstall
linux-modules-extra-4.15.0-42-generic   install
linux-sound-base                        install
pptp-linux                              install
syslinux                                install
syslinux-common                         install
syslinux-legacy                         install
util-linux                              install
```

状态为`deinstall`即已经卸载，如果觉得看着不舒服的话可以使用`purge`连配置文件里一起彻底删除，清理内核列表

```csharp
rew $ sudo apt-get purge \
linux-headers-4.15.0-39 \
linux-headers-4.15.0-39-generic \
linux-image-4.15.0-39-generic \
linux-modules-4.15.0-39-generic \
linux-modules-extra-4.15.0-39-generic
```

### 第四步：更新系统引导

 删除内核后需要更新`grub`移除失效的启动项

```ruby
rew $ sudo update-grub  #根据情况选择grub/grub2
```



