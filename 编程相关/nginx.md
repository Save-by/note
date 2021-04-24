# nginx

## 安装

> Debian系统

```sh
#自动安装
apt-get update
apt-get install nginx
```

> Windows系统

下载对应压缩包，解压



## 使用

### 启动

```
nginx
```



### 停止

```
nginx -s stop
nginx -s quit
```

### 文件分包

- /usr/sbin/nginx：主程序
- /etc/nginx：存放配置文件
- /usr/share/nginx：存放静态文件
- /var/log/nginx：存放日志



## 一些问题

阿里云会在配置免费的ssl后，https://域名:443 会被拦截

解决：可以开放其他端口如444，如果需要，可以进行转发