# Linux基本常用操作

**命令大多数的基本格式**

> [指令] [选项] [操作对象]

### ls 查询目录中的文件

-l 显示文件和目录的详细资料

-a 显示隐藏文件 

```sh
ls -a /usr 显示/usr目录下所有且包括隐藏的文件与文件夹
```

### mkdir 创建目录

-p 忽略目录树如果不存在的问题

```sh
mkdir dir1 创建一个叫做 'dir1' 的目录
mkdir dir1 dir2 同时创建两个目录
```

### touch 创建文件

```sh
touch a.txt 创建名为a.txt的文件
```

### rm 删除目录或文件

-r 采取递归的方式

-f 忽略删除确认询问

```sh
rm -f file1 删除一个叫做 'file1' 的文件' 
rm -rf dir1 删除一个叫做 'dir1' 的目录并同时删除其内容 
```

### mv 重命名/移动 一个目录 

```sh
mv dir1 new_dir 重命名/移动 一个目录 
```

### cp 复制文件 

-a 递归复制，复制的数据会bai保留原有数据的时间戳du等信息（具体：时间戳+所有权+复制连结zhi文件属性而非档案本身）

-r 递归复制，复制的数据会使用新的时间戳等信息

```sh
cp file1 file2 复制一个文件 
```

### cd 更换路径

. 当前路径

.. 上一级

/ 根目录

~ 当前用户的主目录

```sh
cd ../root 进入上一级目录的root目录下
```

### pwd 显示工作路径 

```sh
pwd 显示当前工作路径 
```

### 输出重定向

```sh
> 覆写到指定位置
>> 追加到指定位置

ls /usr > /root/a.txt  将/usr目录下的文件名称覆写到/root/a.txt文件里
ls /usr >> /root/b.txt  将/usr目录下的文件名称追加到/root/b.txt文件里
```

### vim 一款（友好）的文本编辑器

```sh
vim test.c 打开test.c文件（vim的更多操作就不一一列举了）
```

### cat 文件查看（直接输出打印）

```sh
cat /proc/cpuinfo 显示CPU info的信息
```

### date 显示操作系统日期 

```sh
date 显示当前系统日期 
date +%F 输出年月日
date "+%F %T" 输出年月日 时分秒

获取之前或者之后的某个时间
date -d "-1 day" "+%Y-%m-%d %H:%M:%S" 获取1天前的时间
date -d "-1 year" "+%Y-%m-%d %H:%M:%S" 获取1年前的时间
date -d "+1 year" "+%Y-%m-%d %H:%M:%S" 获取1年后的时间
```

### df 查看磁盘空间

-h 以较高的可读性显示

```sh
df -h 以较高的可读性显示磁盘空间
```

### free 查看内存使用情况

-b 调整单位为B

-k 同上KB

-m 同上MB

-g 同上GB

-h 自动判断合适的输出单位

```sh
free -m 以单位MB查看内存使用情况
```

### head 查看文件的前n行，如果不指定n，则默认前10行

```sh
head -7 /usr/a.txt 查看/usr/a.txt文件的前7行
```

### tail 查看文件的后n行，如果不指定n，则默认后10行

-f 查看一个文件的动态变化

```sh
tail -7 /usr/a.txt 查看/usr/a.txt文件的后7行
```

### less 查看文件，以较少的内容进行输出，按下功能键（数字+回车、空格+上下）查看更多

### wc 统计文件内容信息（包括行数，单词数，字节数）

-l 表示lines，行数

-w 表示words，单词数

-c 表示bytes，字节数

```sh
wc -lwc a.txt 统计a.txt的行数，单词数，字节数
```

### cal 操作日历

```sh
cal 直接输出当月的日历
cal -3 输出上一个，现在，下一个月的日历
cal -1 这是一，直接输出当月的日历
cal -y 2020 输出2020年的日历
```

### clear / ctrl + L(不用按shift)  清屏

### 管道

管道符 |  （竖线）

一般用于“过滤”，“特殊”，“扩展处理”

前面的输出就是后面的输入

```sh
ls / | grep y     输出根目录下包含"y"字母的文档名称(grep 指令主要用于过滤)
ls / | wc -l      统计根目录下的文件数
```

### hostname 操作服务器的主机名（写（临时的），读）

```sh
hostname 输出完整的主机名
hostname -f 输出当前主机名的FQDN（全限定域名）
```

### id 查看一个用户的基本信息（用户id，用户组id，附加组id...），不指定用户默认当前用户

```sh
id 查看当前用户的基本信息
id root 查看root用户的基本信息

验证用户信息：通过文件/etc/passwd
验证用户组信息：通过文件/etc/group
```

### whoami  查看当前用户名

```sh
whoami 查看当前用户名
```

### ps -ef 主要是查看服务器的进程信息

-e 等价于"-A"，列出全部的进程

-f 显示全部的列

```sh
ps -ef 查看服务器的进程信息
ps -ef | grep 进程名称        搜索相关进程信息
```

### top 查看服务器的进程占的资源

```sh
top 查看服务器的进程占的资源（会自动动态更新）
按1 （这是一）选择是否展开具体的cpu状态
按M 结果按照内存（MEM）从高到低排序
按P 结果按照cpu使用率从高到低排序
按q退出
```

### du -sh 查看目录的真实大小

-s 只显示汇总的大小

-h 以可读性较高的形式显示

```sh
du -sh /etc 查看/etc目录的真实大小
```

### find 查找文件

-name 按文件名搜索（支持模糊搜索）

-type 按照文档的类型搜索（"-"表示文件（在使用find的时候需要使用f来替换），"d"表示文件夹）

语法：find 路径范围 选项 选项的值

```sh
find /etc -type f 查找/etc下的所有文件
```

### service 用于控制一些软件的服务启动/停止/重启

语法：service 服务名 start/stop/restart

```sh
service httpd start 启动apache服务
```

### kill 杀死进程

语法：kill  进程PID

```sh
kill 666 杀死进程PID为666的进程
```

语法：killall  进程名称



### ifconfig  用于操作网卡相关的指令

```sh
ifconfig 显示网卡信息
```

### reboot 重新启动计算机

```sh
reboot 重新启动计算机
reboot -w 模拟重新启动计算机，但不重启（只添加日志）
```

### shutdown 关机（慎用）

```sh
shutdown -h now "系统即将关机，请保存好文档" 直接关机(后面的引号是关机提示)
shutdown -h 21:30 设定定时关机
shutdown -c 取消计划关机
```

```sh
其他关机操作
init 0
halt
poweroff
```

### uptime  输出计算机持续在线时间

```sh
uptime
```

### uname  获取计算机操作系统相关信息

```sh
uname 获取计算机操作系统类型
uname -a 获取计算机操作系统全部信息
```

### netstat  查看网络的连接状态

-t  只列出tcp的协议

-n  将地址从字母组合转化成IP地址，将协议转换成端口号

-l   只显示state（状态）的值为LISTEN（监听）的连接

-p  显示进程的PID与名称

```sh
netstat -tnlp  
```

### man  （manual）手册

语法：man  命令             （按q退出）

```sh
man ls  展示ls命令的手册
```

### 注销其他在线用户

```bash
w #1.查看有多少个用户在登陆
who am i #2.查看当前自己是哪个用户
pkill -kill -t pts/2 #使用pkill命令将想踢出的用户踢出去（这里踢出的用户是pts/2）
```

### 打包、压缩、解压

.tar
解包：tar xvf FileName.tar
打包：tar cvf FileName.tar DirName
（注：tar是打包，不是压缩！）
.gz
解压1：gunzip FileName.gz
解压2：gzip -d FileName.gz
压缩：gzip FileName

.tar.gz 和 .tgz
解压：tar zxvf FileName.tar.gz
压缩：tar zcvf FileName.tar.gz DirName



### 创建用户

```sh
adduser #DeBian系的命令
useradd #通用
```

### 提升用户权限

```sh
#位于 /etc/sudoers（文件需要修改为可写入640，完成后修改回440） 里的
root    ALL=(ALL)     ALL
#后面添加对应用户
```

