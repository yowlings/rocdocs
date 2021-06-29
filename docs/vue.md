# vue入门与精通
## nodejs安装

### Ubuntu

[官网](https://nodejs.org/en/download/current/)下载Linux 64位二进制包解压后移动到/opt/nodejs中。

建立可执行文件链接：

```
sudo ln -s /opt/nodejs/bin/node /usr/local/bin/node
sudo ln -s /opt/nodejs/bin/npm /usr/local/bin/node
```



### MacOS

直接从官网下载安装包安装即可。



### 更换npm的安装镜像源

```
npm config set registry https://registry.npm.taobao.org
```



## npm与cnpm

### npm

- 允许用户从NPM服务器下载别人编写的第三方包到本地使用。
- 允许用户从NPM服务器下载并安装别人编写的命令行程序到本地使用。
- 允许用户将自己编写的包或命令行程序上传到NPM服务器供别人使用

### npm命令

- `npm -v` 来测试是否成功安装
- 查看当前目录已安装插件：`npm list`
- 更新全部插件： `npm update [ --save-dev ]`
- 使用 npm 更新对应插件： `npm update <name> [ -g ] [ --save-dev]`
- 使用 npm 卸载插件： `npm uninstall <name> [ -g ] [ --save-dev ]`

### cnpm

- 淘宝团队做的国内镜像，因为npm的服务器位于国外可能会影响安装。淘宝镜像与官方同步频率目前为 10分钟 一次以保证尽量与官方服务同步。
- 安装：命令提示符执行
   `npm install cnpm -g --registry=https://registry.npm.taobao.org`
- `cnpm -v` 来测试是否成功安装

##### 通过改变地址来使用淘宝镜像

- npm的默认地址是`https://registry.npmjs.org/`
- 可以使用`npm config get registry`查看npm的仓库地址
- 可以使用`npm config set registry https://registry.npm.taobao.org`来改变默认下载地址，达到可以不安装`cnpm`就能采用淘宝镜像的目的，然后使用上面的get命令查看是否成功。

### nrm

- `nrm`包安装命令： `npm i nrm -g`

- `nrm`能够管理所用可用的镜像源地址以及当前所使用的镜像源地址，但是只是单纯的提供了几个url并能够让我们在这几个地址之间方便切换

  即nrm list，查看所有可用的镜像，并可以切换。*号表示当前npm使用的地址，可以使用命令

  ```
  nrm use taobao
  ```

  或 

  ```
  nrm use npm
  ```

  来进行两者之间的切换。

  ![img](https:////upload-images.jianshu.io/upload_images/14847866-ef4b7d4719a3efe8.png?imageMogr2/auto-orient/strip|imageView2/2/w/382/format/webp)

  nrm ls命令

### -g -S -D

- `-g`：全局安装。 将会安装在C：\ Users \ Administrator \ AppData \ Roaming \ npm，**并且写入系统环境变量**；非全局安装：将会安装在当前定位目录;全局安装可以通过命令行任何地方调用它，本地安装将安装在定位目录的node_modules文件夹下，通过要求调用;
- `-S`：即`npm install module_name --save`,写入`package.json`的`dependencies` ,`dependencies` 是需要发布到生产环境的，比如jq，vue全家桶，ele-ui等ui框架这些项目运行时必须使用到的插件就需要放到`dependencies`
- `-D`：即`npm install module_name --save-dev`,写入`package.json`的`devDependencies` ,`devDependencies` 里面的插件只用于开发环境，不用于生产环境。比如一些babel编译功能的插件、webpack打包插件就是开发时候的需要，真正程序打包跑起来并不需要的一些插件。

> 为什么要保存在`package.json`  因为node_module包实在是太大了。用一个配置文件保存，只打包安装对应配置文件的插件，按需导入。

## Macos 安装依赖包报错

更新Mac系统后，在用npm安装依赖包的时候总会报这个错误：`gyp: No Xcode or CLT version detected!`
 查找了网上的解决办法，基本上都是清一色的说执行这个命令即可：`sudo xcode-select --install`
 可执行后安装npm包还是会报上面的错误提示，虽然没什么实质的影响，但看着这错误提示不舒服，便继续寻找解决的办法。
 功夫不负有心人，在国外的一个网站上找到了解法：

- Step1: 输入`xcode-select --print-path`查看 command-line tools 的安装路径，不出意外显示的结果应该是`/Library/Developer/CommandLineTools`
- Step2: 输入`sudo rm -r -f /Library/Developer/CommandLineTools`把 command-line tools 从系统移除掉
- Step3: 最后输入`xcode-select --install`重新安装



### vue-cli4 项目运行报错

> 错误内容：Package exports for '/xx/node_modules/colorette' do not define a valid '.' target

最新需要搭建一个新的平台用来存放公用组件，于是就按照用最新的脚手架去搭建，但是运行的时候报错

 Package exports for '/xx/node_modules/colorette' do not define a valid '.' target

试了很多方法，比如安装colorette这个包，删除整个node_module，重新安装等各种方式均不生效

解决方案：我自己本地node版本13.1.0，重新安装了稳定版本的node和最新版本的node，再次运行项目发现可以行。

## Vue-cli4的eslint配置问题

vue-cli3按照官网教程配置搭建后，发现每次编译，eslint都抛出错误。
 直接把vue.config.js中将以下三项设置为false

```css
devServer: {
  overlay: {
    warnings: false,
      errors: false
  },
  lintOnSave: false
}
```

