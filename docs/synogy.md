# 群晖配置

## nginx配置

首先，修改群晖配置能够ssh登陆这里就不再赘述了。

群晖系统自带安装了nginx，配置文件目录为/etc/nginx/nginx.conf。

但是，配置文件无法直接修改，因为修改之后在重启nginx服务时会自动重置为原来的样子，修改丢失因而无法生效。

然而，群晖做了对nginx的80端口向5000端口的重定向，从而使我们想用起来默认的web 80端口比较困难。

为了实现对群晖nginx的自定义，找了很多办法，网上没有直接能查到的行之有效的办法。

最终，我将实现方法总结如下。

### 群晖的nginx配置文件嵌套机制

为了实现自定义nginx配置而不被重置，我们首先需要明白其重置的原理。

群晖的nginx配置文件/etc/nginx/nginx.conf是由多个文件相互包含最终生成的。

对于80端口，/etc/nginx/nginx.conf主要包含在/usr/syno/share/nginx/目录下的文件WWWService.mustache，而该文件又进一步包含了WWW_Main.mustache文件，这就是我们需要修改的关键文件所在。

### 修改关键文件

最终修改完成的两个文件如下：

WWW_Main.mustache

```
server_name _;
autoindex on;  # 开启目录文件列表
autoindex_exact_size on;  # 显示出文件的确切大小，单位是bytes
autoindex_localtime on;  # 显示的文件时间为文件的服务器时间
charset utf-8,gbk,gb2312;  # 避免中文乱码

location /collection {
	alias /volume3/collection;
}
location /mm {
	alias /volume2/mm;
}
location /tv {
	alias /volume1/tv;
}

location /movie {
	alias /volume2/movie;
}


{{! > /usr/syno/share/nginx/X-Accel}}


#include app.d/www.*.conf;
#include app.d/alias.*.conf;
#include /usr/syno/share/nginx/conf.d/www.*.conf;
#include conf.d/www.*.conf;

{{! package disable page's logo}}
#location = /webdefault/images/logo.jpg {
#    alias /usr/syno/share/nginx/logo.jpg;
#}

{{! > /usr/syno/share/nginx/error_page}}
{{! > /usr/syno/share/nginx/LetsEncrypt}}
{{! for webstation super location block}}
{{! should be placed at the end of this server block}}
{{! but before redirect 80 to 5000 location}}
#include app.d/.location.webstation.conf*;

#location / {
    #rewrite ^ / redirect;
#}

```

WWWService.mustache

```
server {
    listen 80 default_server{{#reuseport}} reuseport{{/reuseport}};
    listen [::]:80 default_server{{#reuseport}} reuseport{{/reuseport}};

#    gzip on;

    {{> /usr/syno/share/nginx/WWW_Main}}

#    location ~ ^/$ {
#        rewrite / http://$host:{{DSM.port}}/ redirect;
#    }
}

server {
    listen 443 default_server ssl{{#reuseport}} reuseport{{/reuseport}};
    listen [::]:443 default_server ssl{{#reuseport}} reuseport{{/reuseport}};
    {{#DSM.https.compression}}
    gzip on;
    {{/DSM.https.compression}}

    {{! > /usr/syno/share/nginx/WWW_Main}}

#    location ~ ^/$ {
#        rewrite / https://$host:{{DSM.ssl.port}}/ redirect;
#    }
}

```

### 重启nginx服务

```
synoservicecfg --restart nginx
```



## 如何给群晖Nas的docker换个源提升镜像下载速度

之前有小伙伴问到下载dockers镜像时候出现速度慢或者失败的问题，本来觉得很简单没有必要出篇文来介绍，后来又有人问道，因为问多了可能真的有朋友还不知道方法，最后想想还是出篇文吧。

其实下载的快慢很大因素和网络质量有关，也许是远程的也许是本地，总之我们先来解决远程的问题，本地话就要自己找原因咯。

直接开始吧：

1. 打开**控制面板**，找到**终端机和SNMP**设置项目

[![终端机和SNMP](https://qnam.smzdm.com/201911/23/5dd8fbe7a5bed4549.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_2/)终端机和SNMP

2. 勾选SSH功能，这里强调一些，设置完成后一定要记得把它关掉。这算是一个危险操作。

[![勾选ssh](https://am.zdmimg.com/201911/23/5dd8fbe7a7c707972.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_3/)勾选ssh

3. 我这里是Windows环境所以直接试用git的终端工具，这工具虽然一些命令很接近Linux的终端，但是还是非常不一样的。当然还有其他更好用工具，我就不一一介绍了。解决问题最简单的方式最好。

[![使用git的终端工具](https://qnam.smzdm.com/201911/23/5dd8fbe7aa17d311.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_4/)使用git的终端工具

4. 使用以下命令进入你的Nas的终端环境

[![输入Nas账户相关](https://qnam.smzdm.com/201911/23/5dd8fbe7a6c5660.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_5/)输入Nas账户相关

5. 如果你是第一次登录，你们请输入yes,将账户和访问信息保存到电脑上的.ssh[文件夹](https://www.smzdm.com/fenlei/wenjianjia/)中，后面会提示你输入password：也就是密码。（这里的账户密码都是你的Nas管理员群组的账号密码，另外输入密码时候是没有光标提示的，不是没反应，输入完回车就可以了）

[![第一次连接需要确认](https://qnam.smzdm.com/201911/23/5dd8fbe7b60154771.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_6/)第一次连接需要确认

6. 获得root权限，输入以下命令

[![一定要记得先拿权限](https://qnam.smzdm.com/201911/23/5dd8fbe7aab299378.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_7/)一定要记得先拿权限



7. 使用vim编辑器直接编辑docker的配置文件。输入以下命令：vi /var/packages/Docker/etc/dockerd.json



[![直接编辑配置文件](https://qnam.smzdm.com/201911/23/5dd8fbe89b1c458.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_8/)直接编辑配置文件



下图这里是vim编辑器这里可能用得到的命令



[![其实Vim很强大](https://qnam.smzdm.com/201911/23/5dd8fbe8a31a36202.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_9/)其实Vim很强大



8. 先用方向键将光标移动到“registry-mirrors”对应的中括号里边（如果你都会hjkl这样玩，当我没说），按I键插入编辑模式，输入以下网址的任意一个。按Esc键退出编辑模式，按双引号: 输入x 退出vim编辑器，其实已经保存了有些人习惯是wq其实也是一样的效果，写入退出的意思。

首次进入时出现的样子

[![未修改前](https://qnam.smzdm.com/201911/23/5dd8fbe99007e4428.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_10/)未修改前

修改过后出现的样子

[![修改后](https://qnam.smzdm.com/201911/23/5dd8fbe9be2f65008.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_11/)修改后

如果出现了下图这个错误，就是你没有root权限来编辑这个配置文件，输入命令:e!推到原始状态，再输入:x退出文件编辑，重新执行步骤6的操作

[![权限错误](https://qnam.smzdm.com/201911/23/5dd8fcc91c2962099.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_12/)权限错误

国内的镜像源地址：

- htt[ps](https://pinpai.smzdm.com/161140/)://registry.docker-cn.com
- http://hub-mirror.c.163.com
- https://3laho3y3.mirror.aliyuncs.com
- http://f1361db2.m.daocloud.io
- https://mirror.ccs.tencentyun.com

[![国内镜像仓库](https://qnam.smzdm.com/201911/23/5dd8fbe9dcf5c9478.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_13/)国内镜像仓库

9. 重新启动docker服务，既然都在终端了就终端直接重启，没必要回到[群晖](https://pinpai.smzdm.com/2315/)的图形界面上去重启了。输入以下命令：synoservice --restart pkgctl-Docker

[![重启docker命令](https://qnam.smzdm.com/201911/23/5dd8fc65d5df15865.png_e680.jpg)](https://post.smzdm.com/p/ag82opxd/pic_14/)重启docker命令

10. 输入命令exit退出root权限，在输入命令exit结束终端

11. 进入控制面板把勾选的ssh功能取消的，保存应用。

## 总结

其实没说明好特别去总结的，当然也有其他的方式，有很多小伙伴看到命令行的东西就直接吓退了，其实没有必要很多教程都没有把东西写明白告诉你什么意思，导致很多初阶玩家对这种东西很抗拒，其实弄明白命令的意思其实也就是那么回事。其实完全好比在Windows下面，进入一个文件夹下面打开一个文本文件，修改和增加一个网址就可以了。只不过在Linux下是以命令的方式去执行，[键盘](https://www.smzdm.com/fenlei/jianpan/)用得多[鼠标](https://www.smzdm.com/fenlei/shubiao/)用得少而已。