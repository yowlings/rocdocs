# Linux程序自启动

## 开机自启

创建并编辑自启动脚本

```bash
sudo vi /etc/rc.local
sudo chmod u+x /etc/rc.local
```

设置启动服务器，服务器路径在/etc/systemd/system/rc-local.service

```
[Unit]
Description=Run script at startup after network becomes reachable
After=network.target
 
[Service]
Type=simple
RemainAfterExit=yes
ExecStart=/etc/rc.local
TimeoutStartSec=0
 
[Install]
WantedBy=default.target

```

```
ExecStart=<path of shell>
```

为脚本所在路径，此处设置为刚才编辑的/etc/rc.local

使服务生效。

```bash
sudo systemctl enable rc-local.service
```

此后机器即可在开机后自动运行脚本指令。

另外，如需在开机下重启该服务，可直接在修改脚本之后重启服务即可。

```bash
sudo service rc-local restart
```



## 定时启动

定时任务文件位置/etc/crontab，

```
*/1 2 3,5 1-3 4 root bash /home/plan/Documents/te/temp/test4.sh
```

例子中为1到3月份的3日和5日的周四的2点钟每1分钟（理解意思就好，虽然不通，实际情况自定）以root（用户）身份执行后面的命令。

Minute ：分钟（0-59），表示每个小时的第几分钟执行该任务
Hour ： 小时（1-23），表示每天的第几个小时执行该任务
Day ： 日期（1-31），表示每月的第几天执行该任务
Month ： 月份（1-12），表示每年的第几个月执行该任务
DayOfWeek ： 星期（0-6，0代表星期天），表示每周的第几天执行该任务

“\*” ,代表所有的取值范围内的数字；
“/” , 代表”每”（“*/1”，表示每5个单位）；
“-” , 代表从某个数字到某个数字（“1-3”，表示1-3个单位）；
“,” ,分开几个离散的数字；

