# docker

> 解决环境不一致的问题
>
> 可以相互隔离
>
> 可以弹性扩展
>
> 降低学习成本

### docker的思想

1. 集装箱

   将所有需要的内容放到不同的集装箱中，谁需要这些环境直接拿就可以

2. 标准化

   运输的标准化

   命令的标准化

   提供了REST的API ：衍生出了很多的图形界面，比如Rancher

3. 隔离性

   Docker在运行集装箱里的内容时，会在Linux的内核中，单独开辟一片空间，中片空间不会影响到其他程序



- 注册中心（码头，上面放的就是集装箱）

- 镜像（集装箱）

- 容器（运行起来的镜像）

### 安装

1. 安装Docker

   ```sh
   使用国内 daocloud 一键安装命令：
   curl -sSL https://get.daocloud.io/docker | sh
   ```

2. 启动，设置

   ```sh
   systemctl start docker 启动
   systemctl enable docker 设置为开机自启动
   
   
   systemctl disable docker 设置为开机不能自启动（自己想的时候再用）
   ```

3. 测试

   ```sh
   docker run hello-world holloWorld的测试
   ```

### docker的中央仓库

1. docker的官方的中央仓库，镜像全，但服务器在国外
2. 国内的镜像网站：网易蜂巢，daoCloud
3. 在公司内部会采用私服的方式拉取镜像

### 镜像的操作

1. 拉取镜像到本地

   ```
   docker pull 镜像名称[:tag]
   括号内表示版本，不填则使用默认版本
   或者
   docker pull url路径
   
   例如
   docker pull daocloud.io/library/tomcat:8.5.15-jre8   
   ```

2. 查看镜像

   ```
   docker images 查看全部镜像
   ```

3. 删除本地镜像

   ```
   docker rmi 镜像的标识（IMAGE ID）
   ```

4. 镜像的导入导出

   ```
   导入
   docker load -i 镜像文件
   导出
   docker save -o 导出的路径 镜像id
   修改镜像名称
   docker tag 镜像id 新镜像名称:版本
   ```

### 容器的操作

1. 运行容器

   ```
   简单操作
   docker run 镜像的标识/镜像名称[:tag]
   常用参数
   docker run -d -p 宿主机端口:容器端口 --name 容器名称 镜像的标识/镜像名称[:tag]
   
   -d    代表后台运行容器
   -p 宿主机端口:容器端口   为了映射Linux端口与容器的端口
   --name  指定容器名称
   ```

2. 查看正在运行的容器

   ```sh
   docker ps [-qa]
   -a 查看全部容器，包括没有运行的容器
   -q 只查看容器的标识
   
   docker ps 查看正在运行的容器
   docker ps -q 查看正在运行的容器，且只显示标识
   ```

3. 查看容器的日志

   ```sh
   docker logs -f 容器id
   -f 可以滚动查看日志的最后几行
   ```

4. 进入到容器内部

   ```sh
   docker exec -it 容器id bash
   ```

5. 删除容器（不过要先停止）

   ```sh
   docker stop 容器id 停止容器
   docker stop $(docker ps -qa) 停止所有
   
   docker rm 容器id
   docker rm $(docker ps -qa) 删除所有
   ```

6. 启动容器

   ```sh
   docker start 容器id
   ```

### 数据卷

> 数据卷：可以将宿主机的一个目录映射到容器的一个目录中。
>
> 可以在宿主机中操作目录中的内容，那么容器内部映射的文件，也会跟着一起改变。

1. 创建数据卷

   ```sh
   docker volume create 数据卷名称
   创建数据卷后，会默认存放在一个目录下 /var/lib/docker/volumes/数据卷名称/_data
   data里存放具体的数据
   ```

2. 查看数据卷的详细信息

   ```sh
   docker volume inspect 数据卷名称
   ```

3. 查看全部数据卷

   ```sh
   docker volume ls
   ```

4. 删除数据卷

   ```sh
   docker volume rm 数据卷名称
   ```

5. 应用数据卷

   ```sh
   #当映射数据卷时，如果数据卷不存在，docker会帮忙自动创建
   docker run -v 数据卷名称:容器内部路径 镜像id
   #直接指定一个路径作为数据卷的存放位置（与上一个方法相比，这个数据卷不会自动拉取映射路径里的原内容，推荐使用）
   docker run -v 路径:容器内部路径 镜像id
   ```




### Docker自定义镜像

1. 创建一个Dockerfile文件，并且指定自定义镜像信息

   Dockerfile 文件中常用的内容

   - from：指定当前自定义镜像依赖的环境
   - copy：将相对路径下的内容复制到自定义镜像中
   - workdir：声明镜像的默认工作目录
   - cmd：需要执行的命令（在workdir下执行的，cmd可以写多个，只以最后一个为准）

   ```sh
   #例子
   from daocloud.io/library/tomcat:8.5.15-jre8
   copy ssm.war /usr/local/tomcat/webapps
   ```

2. 将准备好的Dockerfile和相应文件拖拽到Linux系统中，通过Docker的命令制作镜像

   ```sh
   docker build -t 镜像名称:[tag] .
   #最后一个点表示文件在当前目录下
   ```

   

### Docker-Compose

>之前运行一个镜像，要添加大量的参数
>
>可以通过Docker-Compose编写这些参数
>
>Docker-Compose可以帮助我们批量的管理容器
>
>只需要通过一个docker-Compose.yml文件去维护即可

1. 下载Docker-Compose
   1. 去GitHub官网下载docker-compose
   2. 将下载好的文件放到Linux系统
   3. 将Docker-Compose文件的名称修改一下（为了方便），同时调整Docker-Compose文件为可执行文件
   4. 添加环境变量





















## 安装MySQL问题

问题：无法远程连接

解决：

进入容器：

```
docker exec -it 62349aa31687 /bin/bash
```

进入mysql：

```
mysql -uroot -p
```

授权：

```
mysql> GRANT ALL ON *.* TO 'root'@'%';
```

刷新权限：

```
mysql> flush privileges;
```

更新加密规则：

```
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER;
```

更新root用户密码：（这里的123456修改为自己的密码）

```
mysql> ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';
```

刷新权限：

```
mysql> flush privileges;
```

 























