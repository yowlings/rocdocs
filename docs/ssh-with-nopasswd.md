# Ubuntu实现免密码登录ssh

### 安装ssh

在服务器与登录客户端机器上都安装ssh软件。
`sudo apt install ssh`
### 配置ssh客户端hosts
编辑客户端的/etc/hosts文件，添加对服务器ip的服务解析。
示例如下：
```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
39.105.40.54    droid
192.168.9.18     zdwp
192.168.2.106   home
47.94.225.41    roc
```
### 生成秘钥
在客户端生成秘钥：
`ssh-keygen`
然后一直enter即可，完毕后会在用户目录生成.ssh文件夹和秘钥公钥文件。
```
.ssh/
├── authorized_keys
├── id_rsa
└── id_rsa.pub
```
复制id_rsa.pub中的内容：
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDT0nT2EIgTNPor11neeFwtM0LLWHO3jMqlrIosuCts7iLmybRVpaTm1SeKbTjM1WAT+mEeB8SYD+l1HZJY7rZ2kHAZo0StdoWN8D+eQ8MRbu+yXcnab/IGGdh0wNhOwDa8QhKIEHWZ7PzNUPsFgHm3eX9txyrgo2nKCN+eaWMsOWzTuo9wY6vRY0PYf2EqcOcBzbQrzJn46ynIYQW23Q+61W4JJEWA6nNDdkgEfCCJNuE/TX28yvo0eqZ0BY2so0fDhr/OhASDSGVAFQwM5n13mui8FPBmlIeN+a90FCwO9/zjls3TrmC38/+vh5VUmsiliNaszYbyKC5arXF2JSI7 zdwp@zdwp-PowerEdge-T30
```
在服务器中手动创建文件.ssh/authorized_keys文件，并将以上复制的内容粘贴到文件中保存。
### 服务器更改sshd配置文件
修改服务器上的/etc/ssh/sshd_config文件，修改:
`AuthorizedKeysFile      /home/zdwp/.ssh/authorized_keys`
即授权秘钥文件指向刚才创建的文件。

### 服务器重启ssh服务
修改完配置文件之后记得重启ssh服务：
`sudo service ssh restart`
然后在客户端就可以直接使用
`ssh zdwp@zdwp`
免密登录，无需输入密码。
其中第一个zdwp为服务器用户名，第二个zdwp是在客户端解析的服务器ip的名字。