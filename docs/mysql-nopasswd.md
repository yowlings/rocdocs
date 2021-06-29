# ubuntu18.04 首次登录mysql未设置密码或忘记密码解决方法

## 查看当前密码

```
sudo cat /etc/mysql/debian.cnf
```

## 登录当前用户

```
mysql -u debian-sys-maint -p
//注意! 
//这条指令的密码输入是输入第一条指令获得的信息中的 password = ZCt7QB7d8O3rFKQZ 得来。
//请根据自己的实际情况填写！
```

## 修改密码

```
use mysql;
// 下面这句命令有点长，请注意。
update mysql.user set authentication_string=password('root') where user='root' and Host ='localhost';
update user set plugin="mysql_native_password"; 
flush privileges;
quit;
```

## 使用root与新密码登录

```
sudo service mysql restart
mysql -u root -p // 启动后输入已经修改好的密码：root
```

