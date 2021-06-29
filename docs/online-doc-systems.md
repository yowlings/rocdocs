# 在线文档管理系统哪家强

> 最近为公司部署了一套**文档管理系统**，使用开源项目showdoc，甚是简单。不过也经历了不少坑和学习了一些新技能，记录一下。

## 部署过程
首先是在**今日头条**app上看新闻，无意间读到一篇介绍showdoc项目的文章，然后刚好最近这阵子正在为苦于找不到一款好用的文档管理系统方案而发愁，于是乎收藏了一下。
具体接触和了解了showdoc项目之后，发现确实非常实用，实质名归，开源的像这么好用的项目真不多见。
部署过程也是非常简单，直接引用[官方的帮助文档](https://www.showdoc.cc/help?page_id=1385767280275683 "官方的帮助文档")吧。
在逐渐学习和掌握的过程中，分别经历了以下几个过程：

1. 在自己笔记本上试，本地安装环境和使用；
2. 完成1的基础上在本地服务器上安装环境使用，确实很好用；
3. 上云端服务器

由于云端服务器已经安装了其他的服务器环境，而且软件版本之低再怎么吐槽也不过分。期初是考虑要不找个别的云服务器来安装，或者重新买一台服务器来部署。
综合考虑了成本和保持公司官网统一性，突然意识到现有官网服务器+docker不就是我最好的解决方法！
安装docker

```bash
sudo apt install docker-ce
```

按照官方指导安装和运行showdoc docker镜像。

```bash
 # 原版官方镜像安装命令(中国大陆用户不建议直接使用原版镜像，可以用后面的加速镜像)
 docker pull star7th/showdoc 
 # 中国大陆镜像安装命令（安装后记得执行docker tag命令以进行重命名）
 docker pull registry.cn-shenzhen.aliyuncs.com/star7th/showdoc
 docker tag registry.cn-shenzhen.aliyuncs.com/star7th/showdoc:latest star7th/showdoc:latest 
 ##后续命令无论使用官方镜像还是加速镜像都需要执行
 #新建存放showdoc数据的目录
 mkdir /showdoc_data
 mkdir /showdoc_data/html
 chmod  -R 777 /showdoc_data
 #启动showdoc容器
 docker run -d --name showdoc -p 4999:80 -v /showdoc_data/html:/var/www/html/ star7th/showdoc
```

完成，就这么简单。

## 端口问题
由于docker运行showdoc的镜像使用的是端口映射方式，将镜像的80端口挂载到了服务器的4999端口，发现在浏览器中怎么输入地址带端口号，都无法实现对showdoc的访问。
但是在服务器本地，运行指令：

```bash
wget http://127.0.0.1:4999
```

是能够获取到docker镜像的页面的，这说明showdoc是正常运行的。

是能够获取到docker镜像的页面的，这说明showdoc是正常运行的。

这问题就非常无厘头了！

> 折腾了半天时间，最后发现竟然是云服务器的端口出于安全考虑，关闭了所有其他非使用端口，只开放了类似于80,443,3389等端口！4999并不在开放之列。

捎带介绍一下云服务器开放的几个端口的用途吧：

|  端口号 | 用途  |
| ------------ | ------------ |
| 80  | http正常访问的网站端口  |
| 443  | ssl加密的验证端口，也就是实现http->https的端口  |
| 3389  | showdoc文档管理平台  |

## 路径重定向到端口
经过以上步骤，目前云服务器上的showdoc总算是可以正常使用了。
可是，网页地址带端口号的方式总是觉得让人不得劲！
我们的官网网址是：
> https://www.droid.ac.cn/

而我们的文档管理平台的地址是：
> http://www.droid.ac.cn:3389/

为了保证与官网的网址风格一致，我们的目标是将文档管理平台的地址变为：
> https://www.droid.ac.cn/docs/

而不影响其他所有功能。
### 方法一 请求重写
在网上查了半天，发现第一种方式是请求重写的方式实现重定向。也就是在/etc/nginx/sites-available/default文件中的server{}加入

    location /docs/ {
        rewrite ^/docs/(.*)$   http://www.droid.ac.cn:3389/$1;
    }

但是这种方式只是强制的将对/docs/目录的访问变成对端口的访问，浏览器输入地址之后只是跳转到了端口3389的网页，而且网页地址也变回来了，失败！
### 方法二 绝对路径重定向
第二种方法是在/etc/nginx/sites-available/default文件中的server{}加入：

    location /docs/ {
            proxy_pass http://127.0.0.1:3389/;
    }

这种方法确实重定向成功了，但是有个致命的问题在于，对于网页请求，它能够正常重定向，但是对于类似于api的请求，或者资源的请求，比如图片，它就失效了，从而导致无法正常注册和登录。

### 方法三 相对路径重定向

稍微修改第二种方法，在/etc/nginx/sites-available/default文件中的server{}加入：

    location ^~ /docs/ {
            proxy_pass http://127.0.0.1:3389/;
    }

就这小小的一个`^~`的差别，就是本次重定向的关键。

## Tips
> 1. 修改nginx配置文件之后记得运行`service nginx reload`以保证修改生效；
2. 大部分涉及到环境配置的项目，都可以考虑使用docker来实现，非常方便；
3. 在路径重定向之前记得将同名路径移除，以免出现冲突，如本项目中需要将/var/www/html/路径下的docs文件夹重命名。

## 总结
经过多番折腾，发现目前出色的文档管理系统有三个：
1. 与github无缝衔接的[Read The Doc](https://readthedocs.org/ "Read The Doc")使用的[Sphinx](http://www.sphinx-doc.org/en/master/ "Sphinx"),如[Cartographer项目](https://google-cartographer.readthedocs.io/en/latest/ "Cartographer项目")就是使用该文档系统管理的。
2. 使用Markdown文件编译成静态网页的[MkDocs项目](https://www.mkdocs.org/ "MkDocs项目")，搭配ReadTheDoc的主题，也是相当不错的。国内知名的激光雷达机器人厂商[上海思岚科技](https://developer.slamtec.com/docs/slamware/ros-sdk/2.6.0_rtm/ "上海思岚科技")就是使用的该文档管理系统。
3. 本文所用的[showdoc](https://www.showdoc.cc/ "showdoc")开源项目，[github开源地址](https://github.com/star7th/showdoc "github开源地址")。

下面简单对比了以下三者的优缺点。

| 特点  | Sphinx  | MkDocs  | Showdoc  |
| ------------ | ------------ | ------------ | ------------ |
| 是否开源  |  是 | 是  | 是  |
| 编译成静态  | 是  | 是  | 否  |
|  用户管理 |  否 | 否  | 是  |
|  多人协作 | 否  | 否  | 否  |
| 在线可视化编写  | 否  | 否  | 是  |
| github支持  |  是 | 否  | 否  |
| github管理repo  |  可以 |  可以 |  不可以 |
|  数据库 | 无  |  无 |  有 |
| markdown支持  |  多种类支持，主rts |  强 |  强 |
|  导出pdf | 完美，依赖latex |  无，插件难装 |  无，可直接打印网页 |
|  导出word | 无  |  无 |  有，不完美，能看，有乱格式 |
|  Tip,Warning,Error蓝黄红Note| 有，挺好  |  有，一般 |  无，建议作者加入 |


我最后选择了站Showdoc，以上三种都部署和进过坑，以资借鉴。