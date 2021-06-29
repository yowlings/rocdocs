# Docker部署软件

## docker安装与使用

### docker安装

```
sudo apt install docker.io -y
```

### docker常用指令

当前已下载的镜像

```
docker images
```

查看正在运行的实例

```
docker ps
```

搜索网上的镜像

```
docker search gitlab
```

下载镜像

```
docker pull gitlab/gitlab-ce
```

启动/停止实例

```
docker start/stop 实例名
```

运行示例

```bash
docker run -d -p 443:443 -p 8081:80 -p 222:22 --name=gitlab --restart=always -v /home/zdwp/gitlab/config:/etc/gitlab -v /home/zdwp/gitlab/log:/var/log/gitlab -v /home/zdwp/gitlab/data:/var/opt/gitlab ffadb2afd260
```

## Docker部署gitlab

```bash
docker search gitlab
docker pull gitlab/gitlab-ce
mkdir ~/gitlab
mkdir -p ~/gitlab/config
mkdir -p ~/gitlab/log
mkdir -p ~/gitlab/data
docker run -d -p 443:443 -p 8081:80 -p 222:22 --name=gitlab --restart=always -v /home/zdwp/gitlab/config:/etc/gitlab -v /home/zdwp/gitlab/log:/var/log/gitlab -v /home/zdwp/gitlab/data:/var/opt/gitlab ffadb2afd260
```

然后采用

```
docker ps
```

可以看到gitlab正在初始化启动状态starting，过程大概几分钟，启动完成后状态则会变为healthy。