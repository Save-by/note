# Redis

## 背景

### nosql

大数据时代；

大数据，一般的数据库无法进行分析的数据；

历史推进：

1. 单机MYSQL的年代

   app（程序，web）-->dal（数据库连接处理）-->mysql（数据库实例）

2. Memcached（缓存） + MySQL + 垂直拆分（读写分离）

3. 分库分表 + 水平拆分 + MySQL集群

什么是NoSQL ?

NoSQL = Not Only SQL

泛指非关系型数据库，随着web2.0互联网的诞生。

NoSQL特点：

1. 方便扩展（数据之间没有关系，很好扩展）
2. 大数据量，高性能
3. 数据类型是多样型的（不需要事先设计数据库，随取随用）
4. 传统的RDBMS和NoSQL
   1. 传统的RDBMS
      - 结构化组织
      - SQL
      - 数据和关系都存在单独的表中
      - 操作，数据定义语言
      - 严格的一致性
      - 基础的事务
      - 。。。
   2. NoSQL
      - 不仅仅是数据
      - 没有固定的查询语言
      - 键值对存储，列存储，文档存储，图形数据库（社交关系）
      - 最终一致性
      - CAP定理 和 BASE （异地多活）
      - 高性能，高可用，高可扩
      - 。。。
5. 大数据时代的3V+3高
   1. 海量Volume
   2. 多样Variety
   3. 实时Velocity
   4. 高并发
   5. 高可扩
   6. 高性能



NoSQL的四大分类：

1. KV键值对
2. 文档型数据库（bson格式 和json一样）
   - MongoDB（一般必须掌握）
     - 一个基于分布式文件储存的数据库，c++编写，用来处理大量的文档
     - 一个介于关系型数据库和非关系型数据库中间的产品
   - ConthDB
3. 列存储
   - HBase
   - 分布式文件系统
4. 图关系数据库（存储关系的）
   - Neo4j , InfoGrid

 



## 概述

> Redis是什么？

Redis（Remote Dictionary Server )，即远程字典服务，是一个开源的使用ANSI C语言编写、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库，并提供多种语言的API。从2010年3月15日起，Redis的开发工作由VMware主持。从2013年5月开始，Redis的开发由Pivotal赞助。



> 定义

dis是一个key-value存储系统。和Memcached类似，它支持存储的value类型相对更多，包括string(字符串)、list(链表)、set(集合)、zset(sorted set --有序集合)和hash（哈希类型）。这些数据类型都支持push/pop、add/remove及取交集并集和差集及更丰富的操作，而且这些操作都是原子性的。在此基础上，redis支持各种不同方式的排序。与memcached一样，为了保证效率，数据都是缓存在内存中。区别的是redis会周期性的把更新的数据写入磁盘或者把修改操作写入追加的记录文件，并且在此基础上实现了master-slave(主从)同步。

Redis 是一个高性能的key-value数据库。 redis的出现，很大程度补偿了memcached这类key/value存储的不足，在部 分场合可以对关系数据库起到很好的补充作用。它提供了Java，C/C++，C#，PHP，JavaScript，Perl，Object-C，Python，Ruby，Erlang等客户端，使用很方便。 [1] 

Redis支持主从同步。数据可以从主服务器向任意数量的从服务器上同步，从服务器可以是关联其他从服务器的主服务器。这使得Redis可执行单层树复制。存盘可以有意无意的对数据进行写操作。由于完全实现了发布/订阅机制，使得从数据库在任何地方同步树时，可订阅一个频道并接收主服务器完整的消息发布记录。同步对读取操作的可扩展性和数据冗余很有帮助。

redis的官网地址，非常好记，是redis.io。（域名后缀io属于国家域名，是british Indian Ocean territory，即英属印度洋领地），Vmware在资助着redis项目的开发和维护。



> 能干嘛？

1. 内存存储、持久化，内存中是断电即失，所以说持久化很重要（两种持久化方式rdb、aof）
2. 效率高，可以用于高速缓存
3. 发布订阅系统
4. 地图信息分析
5. 计时器、计数器
6. 。。。



## 安装

### Windows

（略）=_=没找到安装包



### Linux

1. 下载安装包

   redis-6.0.9.tar.gz

2. 放到服务器上

3. 解压

   ```bash
   tar -zxvf redis-6.0.9.tar.gz 
   ```

4. 确保安装了gcc，g++（c++的环境）

5. 在解压的文件夹目录下

   ```bash
   make 
   make install
   ```

6. 在默认的路径/usr/local/bin  中新建myconf文件夹，把redis.conf复制进去

7. redis默认不是后台启动的，需要修改文件redis.conf

   ![image-20201208224416069](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201208224416069.png)

8. 启动redis服务（在/usr/local/bin 的路径下）

   ```bash
   redis-server myconf/redis.conf
   ```

9. 使用redis-cli进行测试

   ![image-20201208225648129](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201208225648129.png)

10. 查看redis的进程是否开启

    ![image-20201208230159813](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201208230159813.png)

    ```bash
    ps -ef |grep redis
    ```

11. 如何关闭redis服务

    使用shutdown命令

    ```bash
    shutdown
    ```

    然后exit退出客户端

    ```bash
    exit
    ```

12. 再次查看redis进程是否关闭

    ```bash
    ps -ef |grep redis
    ```

    

## 性能测试

### redis-benchmark

redis-benchmark是一个压力测试工具

```bash
redis-benchmark [option] [option value]
```

![image-20201209104133212](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201209104133212.png)

简单测试一下：

```bash
# 测试：100个并发连接 每个并发100000个请求
redis-benchmark -h localhost -p 6379 -c 100 -n 100000
```

![image-20201209105830939](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201209105830939.png)



## 基础的知识

redis默认有16个数据库

![image-20201209110503209](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201209110503209.png)

默认使用第1个（下标为 0）

可以使用select进行切换数据库

```bash
127.0.0.1:6379> dbsize #查看数据库大小
(integer) 5
127.0.0.1:6379> keys * #查看该数据库所有的key
1) "counter:__rand_int__"
2) "mylist"
3) "name"
4) "myhash"
5) "key:__rand_int__"
127.0.0.1:6379> select 3   #select命令切换数据库，切换到下标为3的数据库，即第4个数据库，默认为下标为0
OK
127.0.0.1:6379[3]> dbsize
(integer) 0
127.0.0.1:6379[3]> keys *
(empty array)
127.0.0.1:6379[3]> 
```

清除数据库（哦吼吼=_=）

```bash
127.0.0.1:6379> flushdb #清除当前数据库

127.0.0.1:6379> flushall #清除所有数据库
```

redis是单线程的（其实一直是多线程的，但默认关闭，6.0之后使用多线程优化了IO，但执行命令的时候还是单线程的）

redis是很快的，redis是基于内存操作，CPU不是redis的性能瓶颈，瓶颈是机器的内存和网络带宽



判断键是否存在

```bash
127.0.0.1:6379> exists name #判断键name是否存在，存在返回1，不存在返回0
```

移动指定key到指定数据库

```bash
127.0.0.1:6379> move name 5 #移动name 到数据库5中
```

移除指定key

```bash
127.0.0.1:6379> del name  #移除name 
```

控制过期

```bash
127.0.0.1:6379> expire name 10 #name在10秒后过期

# 查看指定key过期剩余时间  ttl key 
127.0.0.1:6379> ttl name
(integer) 7
127.0.0.1:6379> ttl name
(integer) 5
127.0.0.1:6379> ttl name
(integer) 3
127.0.0.1:6379> ttl name
(integer) 3
127.0.0.1:6379> ttl name
(integer) 1
127.0.0.1:6379> ttl name
(integer) 0
127.0.0.1:6379> ttl name
(integer) -2
127.0.0.1:6379> ttl name
(integer) -2
```

查看数据类型

```bash
127.0.0.1:6379> keys *
(empty array)
127.0.0.1:6379> set name hhhh
OK
127.0.0.1:6379> set age 1
OK
127.0.0.1:6379> type name #查看name对应数据的数据类型
string
127.0.0.1:6379> type age
string
```

验证登录密码

```bash
127.0.0.1:6379> auth myPassword
```





## 五大数据类型

> 图来自官网

![image-20201209114332811](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201209114332811.png)

![image-20201209114355606](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201209114355606.png)

Redis 是一个开源（BSD许可）的，内存中的数据结构存储系统，它可以用作**数据库**、**缓存**和**消息中间件**。 它支持多种类型的数据结构，如 字符串（strings）， 散列（hashes）， 列表（lists）， 集合（sets）， 有序集合（sorted sets） 与范围查询， bitmaps， hyperloglogs 和 地理空间（geospatial） 索引半径查询。 Redis 内置了 复制（replication），LUA脚本（Lua scripting）， LRU驱动事件（LRU eviction），事务（transactions） 和不同级别的 磁盘持久化（persistence）， 并通过 Redis哨兵（Sentinel）和自动 分区（Cluster）提供高可用性（high availability）。



### String（字符串） 

- keys *
- set
- get
- apend
- serlen

```bash
#############################################################################################
127.0.0.1:6379> keys *  #查看所有key
(empty array)
127.0.0.1:6379> set k1 v1 #设置值
OK
127.0.0.1:6379> append k1 vv1234 #追加字符串
(integer) 8
127.0.0.1:6379> get k1 #获得值
"v1vv1234"
127.0.0.1:6379> append k2 vv1234 #追加字符串，如果不存在，就相当于set key
(integer) 6
127.0.0.1:6379> get k2
"vv1234"
127.0.0.1:6379> strlen k1 #获得字符串的长度
(integer) 8
127.0.0.1:6379> strlen k2
(integer) 6

```

- incr
- decr

```bash
#############################################################################################
#自增incr  
#自减decr

127.0.0.1:6379> set views 0 #设置值
OK
127.0.0.1:6379> get views #获取值
"0"
127.0.0.1:6379> incr views #自增1
(integer) 1
127.0.0.1:6379> incr views #自增1
(integer) 2
127.0.0.1:6379> incr views #自增1
(integer) 3
127.0.0.1:6379> get views #获取值
"3"
127.0.0.1:6379> decr views #自减1
(integer) 2
127.0.0.1:6379> decr views #自减1
(integer) 1
127.0.0.1:6379> decr views #自减1
(integer) 0
127.0.0.1:6379> decr views #自减1
(integer) -1
127.0.0.1:6379> decr views #自减1
(integer) -2
127.0.0.1:6379> decr views #自减1
(integer) -3
127.0.0.1:6379> get views #获取值
"-3"

```

- incrby
- decrby

```bash
################################################################################################
#incrby key increment 可以设置自增步长
#decrby key increment 可以设置自减步长

127.0.0.1:6379> get views
"-3"
127.0.0.1:6379> incrby views 10 #自增10
(integer) 7
127.0.0.1:6379> incrby views 10 #自增10
(integer) 17
127.0.0.1:6379> decrby views 5 #自减5
(integer) 12
127.0.0.1:6379> decrby views 5 #自减5
(integer) 7
127.0.0.1:6379> get views
"7"

```

- getrange
- setrange

```bash
################################################################################################
#字符串范围range

127.0.0.1:6379> keys *
(empty array)
127.0.0.1:6379> set k1 hello,world
OK
127.0.0.1:6379> get k1
"hello,world"
127.0.0.1:6379> getrange k1 0 3 #截取字符串[0,3]的值
"hell"
127.0.0.1:6379> getrange k1 0 -1 #获得全部字符串 与 get 一样
"hello,world"
127.0.0.1:6379> getrange k1 1 -1
"ello,world" #截取字符串下标1至结尾
127.0.0.1:6379> set k2 abcd
OK
127.0.0.1:6379> get k2 
"abcd"
127.0.0.1:6379> setrange k2 1 ** #替换下标1开始的值为**
(integer) 4
127.0.0.1:6379> get k2 
"a**d"

```

- setex
- setnx

```bash
################################################################################################
# setex  #设置过期时间（set with expire）
# setnx  #不存在再设置（set if not exist）（在分布式锁中会常使用）

127.0.0.1:6379> setex k3 30 v3
OK #设置k3的值为v3，过期时间为30秒
127.0.0.1:6379> keys *
1) "k3"
2) "k2"
3) "k1"
127.0.0.1:6379> get k3
"v3"
#这里中间隔了30秒
127.0.0.1:6379> keys *
1) "k2"
2) "k1"
127.0.0.1:6379> get k3
(nil)
127.0.0.1:6379> setnx mykey redis #如果mykey不存在，设置mykey的值为redis
(integer) 1
127.0.0.1:6379> get mykey
"redis"
127.0.0.1:6379> setnx mykey mysql #如果mykey不存在，设置mykey的值为mysql，但mykey存在，所以设置失败
(integer) 0
127.0.0.1:6379> get mykey
"redis"

```

- mset
- mget
- msetnx

```bash
################################################################################################
#批处理 mset mget msetnx

127.0.0.1:6379> flushdb
OK
127.0.0.1:6379> mset k1 v1 k3 v3 k2 v2 #批量设置值
OK
127.0.0.1:6379> keys *
1) "k3"
2) "k2"
3) "k1"
127.0.0.1:6379> mget k1 k2 k3 k4 #批量获取值
1) "v1"
2) "v2"
3) "v3"
4) (nil)
127.0.0.1:6379> msetnx k1 v8 k4 v4 #批量设置不存在的值，具有原子性，必须都不存在才能设置成功
(integer) 0
127.0.0.1:6379> mget k1 k2 k3 k4
1) "v1"
2) "v2"
3) "v3"
4) (nil)

#key可以支持:（冒号）命名
127.0.0.1:6379> mset user:1:age 18 user:1:name zhangshang
OK
127.0.0.1:6379> mget user:1:age user:1:name
1) "18"
2) "zhangshang"

```

- getset

```bash
################################################################################################
#getset 先获取原来的值，再设置

127.0.0.1:6379> FLUSHDB #清空当前数据库
OK
127.0.0.1:6379> getset k1 v1
(nil)
127.0.0.1:6379> getset k1 v2
"v1"
127.0.0.1:6379> get k1 
"v2"


```



### List

> 本质是双端队列

- lpush
- rpush
- lrange
- lpop
- rpop

```bash
#############################################################################################
#lpush 
#rpush
#lrange
#lpop
#rpop
127.0.0.1:6379> lpush list1 1 2 3 #将一个值或多个值，插入到列表头部（左）
(integer) 3
127.0.0.1:6379> lpush list1 4
(integer) 4
127.0.0.1:6379> lpush list1 5
(integer) 5
127.0.0.1:6379> lpush list1 6
(integer) 6
127.0.0.1:6379> lrange list1 0 -1 #获取list中的值
1) "6"
2) "5"
3) "4"
4) "3"
5) "2"
6) "1"
127.0.0.1:6379> lrange list1 0 2 #通过区间获取具体的值
1) "6"
2) "5"
3) "4"
127.0.0.1:6379> rpush list1 7 8 9 #将一个值或者多个值，插到列表尾部（右）
(integer) 9
127.0.0.1:6379> lrange list1 0 -1
1) "6"
2) "5"
3) "4"
4) "3"
5) "2"
6) "1"
7) "7"
8) "8"
9) "9"
127.0.0.1:6379> lpop list1 #左端出队（移除）
"6"
127.0.0.1:6379> rpop list1 #右端出队（移除）
"9"
127.0.0.1:6379> lrange list1 0 -1
1) "5"
2) "4"
3) "3"
4) "2"
5) "1"
6) "7"
7) "8"

```

- lindex

```bash
#############################################################################################
#lindex 下标查询
127.0.0.1:6379> lrange list1 0 -1
1) "5"
2) "4"
3) "3"
4) "2"
5) "1"
6) "7"
7) "8"
127.0.0.1:6379> lindex list1 0 #查看下标为0（第一个，头部）的值
"5"
127.0.0.1:6379> lindex list1 6
"8"

```

- llen

```bash
#############################################################################################
#llen list的长度
127.0.0.1:6379> lrange list1 0 -1
1) "5"
2) "4"
3) "3"
4) "2"
5) "1"
6) "7"
7) "8"
127.0.0.1:6379> llen list1
(integer) 7


```

- lrem

```bash
#############################################################################################
#lrem  移除指定的值
127.0.0.1:6379> FLUSHALL #清空库
OK
127.0.0.1:6379> LPUSH list1 1 2 3 4 #头插法插入 1 2 3 4
(integer) 4
127.0.0.1:6379> LPUSH list1 1 2 3 4 #头插法插入 1 2 3 4 （可以重复的）
(integer) 8
127.0.0.1:6379> lrange list1 0 -1 #查看值
1) "4"
2) "3"
3) "2"
4) "1"
5) "4"
6) "3"
7) "2"
8) "1"
127.0.0.1:6379> lrem list1 1 1 #从头至尾移除1个"1"
(integer) 1
127.0.0.1:6379> lrange list1 0 -1 #查看值
1) "4"
2) "3"
3) "2"
4) "4"
5) "3"
6) "2"
7) "1"
127.0.0.1:6379> lrem list1 2 3 #从头至尾移除2个"3"
(integer) 2
127.0.0.1:6379> lrange list1 0 -1 #查看值
1) "4"
2) "2"
3) "4"
4) "2"
5) "1"


```

- ltrim

```bash

#############################################################################################
# ltrim 通过下标截取指定的长度，会改变原列表
127.0.0.1:6379> rpush list1 one two three four five
(integer) 5
127.0.0.1:6379> lrange list1 0 -1
1) "one"
2) "two"
3) "three"
4) "four"
5) "five"
127.0.0.1:6379> ltrim list1 1 3
OK
127.0.0.1:6379> lrange list1 0 -1
1) "two"
2) "three"
3) "four"

```

- rpoplpush

```bash

#############################################################################################
#rpoplpush 移除列表最后一个元素，将它移动到目标列表中

127.0.0.1:6379> lrange list1 0 -1
1) "two"
2) "three"
3) "four"
127.0.0.1:6379> keys *
1) "list1"
127.0.0.1:6379> rpoplpush list1 list2
"four"
127.0.0.1:6379> keys *
1) "list1"
2) "list2"
127.0.0.1:6379> lrange list2 0 -1
1) "four"
127.0.0.1:6379> rpoplpush list1 list2
"three"
127.0.0.1:6379> rpoplpush list1 list2
"two"
127.0.0.1:6379> rpoplpush list1 list2
(nil)
127.0.0.1:6379> lrange list2 0 -1
1) "two"
2) "three"
3) "four"

```

- lset

```bash

#############################################################################################
#lset 改变指定位置的值

127.0.0.1:6379> lrange list1 0 -1
1) "two"
2) "three"
3) "four"
127.0.0.1:6379> lset list1 0 one
OK
127.0.0.1:6379> lrange list1 0 -1
1) "one"
2) "three"
3) "four"

```

- linsert

```bash

#############################################################################################
#linsert before|after 插入指定值到指定位置
127.0.0.1:6379> FLUSHDB
OK
127.0.0.1:6379> rpush list1 one two three
(integer) 3
127.0.0.1:6379> rpush list1 one two three
(integer) 6
127.0.0.1:6379> lrange list1 0 -1
1) "one"
2) "two"
3) "three"
4) "one"
5) "two"
6) "three"
127.0.0.1:6379> linsert list1 before three 2.5 #插入2.5到第一个three前面
(integer) 7
127.0.0.1:6379> lrange list1 0 -1
1) "one"
2) "two"
3) "2.5"
4) "three"
5) "one"
6) "two"
7) "three"
127.0.0.1:6379> linsert list1 after one 1.5 #插入1.5到第一个one后面
(integer) 8
127.0.0.1:6379> lrange list1 0 -1
1) "one"
2) "1.5"
3) "two"
4) "2.5"
5) "three"
6) "one"
7) "two"
8) "three"

```





### Set

集合，值不能重复



```bash
##############################################################################
#
127.0.0.1:6379> sadd set1 hello #set集合中添加元素
(integer) 1
127.0.0.1:6379> sadd set1 world
(integer) 1
127.0.0.1:6379> sadd set1 hhh
(integer) 1
127.0.0.1:6379> sadd set1 hhh #添加重复的会失败
(integer) 0
127.0.0.1:6379> scard set1 #查看set集合的元素个数
(integer) 3
127.0.0.1:6379> smembers set1 #查看指定set的所有值
1) "world"
2) "hhh"
3) "hello"
127.0.0.1:6379> sismember set1 hello #判断某一个值是不是在set集合中
(integer) 1
127.0.0.1:6379> sismember set1 hello123
(integer) 0


##############################################################################

127.0.0.1:6379> smembers set1
1) "world"
2) "hhh"
3) "hello"
127.0.0.1:6379> scard set1
(integer) 3
127.0.0.1:6379> srem set1 hello world test #移除指定set集合的一个或多个指定元素，其中"test"元素本不存在，但不影响
(integer) 2
127.0.0.1:6379> scard set1
(integer) 1
127.0.0.1:6379> smembers set1
1) "hhh"



##############################################################################

127.0.0.1:6379> smembers set1 #查看值
1) "1"
2) "2"
3) "3"
4) "4"
5) "5"
6) "6"
7) "7"
8) "8"
9) "9"
127.0.0.1:6379> srandmember set1  #随机获取集合中的一个值，默认获取1个
"5"
127.0.0.1:6379> srandmember set1 #随机获取集合中的一个值 
"9"
127.0.0.1:6379> srandmember set1 1 #随机获取集合中的值，指定个数为1
1) "2"
127.0.0.1:6379> srandmember set1 1 #随机获取集合中的值，指定个数为1
1) "8"
127.0.0.1:6379> srandmember set1 3 #随机获取集合中的值，指定个数为3
1) "8"
2) "6"
3) "1"
127.0.0.1:6379> srandmember set1 3 #随机获取集合中的值，指定个数为3
1) "6"
2) "1"
3) "9"
127.0.0.1:6379> srandmember set1 3 #随机获取集合中的值，指定个数为3
1) "3"
2) "7"
3) "9"








##############################################################################


127.0.0.1:6379> smembers set1 #查看值
1) "1"
2) "2"
3) "3"
4) "4"
5) "5"
6) "6"
7) "7"
8) "8"
9) "9"
127.0.0.1:6379> spop set1 #随机移除1个元素，会改变原集合 
"7"
127.0.0.1:6379> spop set1 #随机移除1个元素  
"8"
127.0.0.1:6379> spop set1 #随机移除1个元素  
"3"
127.0.0.1:6379> smembers set1 #查看值
1) "1"
2) "2"
3) "4"
4) "5"
5) "6"
6) "9"
127.0.0.1:6379> spop set1 2 #随机移除指定个数的元素 
1) "6"
2) "5"
127.0.0.1:6379> smembers set1 #查看值
1) "1"
2) "2"
3) "4"
4) "9"



##############################################################################


127.0.0.1:6379> smembers set1 #查看值
1) "1"
2) "2"
3) "4"
4) "9"
127.0.0.1:6379> smove set1 set2 4 #将set集合（这里是set1）中指定元素（这里是4）移动到目标集合（这里是set2）中
(integer) 1
127.0.0.1:6379> smembers set2 #查看值
1) "4"
127.0.0.1:6379> smembers set1 #查看值
1) "1"
2) "2"
3) "9"




##############################################################################


127.0.0.1:6379> smembers set1 #查看set1的元素，有1 2 3 4 5 6 7
1) "1"
2) "2"
3) "3"
4) "4"
5) "5"
6) "6"
7) "7"
127.0.0.1:6379> smembers set2 #查看set2的元素，有5 6 7 8 9 10 11
1) "5"
2) "6"
3) "7"
4) "8"
5) "9"
6) "10"
7) "11"
127.0.0.1:6379> smembers set3 #查看set3的元素，有4 12 13 14
1) "4"
2) "12"
3) "13"
4) "14"
127.0.0.1:6379> sdiff set1 set2 #以set1为基准，查看set1与set2的差集（即set1集合中不存在于set2集合中的元素）
1) "1"
2) "2"
3) "3"
4) "4"
127.0.0.1:6379> sdiff set1 set2 set3 #以set1为基准，查看set1与set2、set3的差集（即set1集合中 既不存在于set2集合，也不存在于set3集合中 的元素）
1) "1"
2) "2"
3) "3"
127.0.0.1:6379> sdiff set2 set1 #以set1为基准，查看set2与set1的差集（即set2集合中不存在于set1集合中的元素）
1) "8"
2) "9"
3) "10"
4) "11"
127.0.0.1:6379> sinter set1 set2 #查看set1与set2的交集
1) "5"
2) "6"
3) "7"
127.0.0.1:6379> sinter set1 set2 set3 #查看set1与set2与set3的交集
(empty array)
127.0.0.1:6379> sunion set1 set2 #查看set1与set2的并集
 1) "1"
 2) "2"
 3) "3"
 4) "4"
 5) "5"
 6) "6"
 7) "7"
 8) "8"
 9) "9"
10) "10"
11) "11"
127.0.0.1:6379> sunion set1 set2 set3 #查看set1与set2与set3的并集
 1) "1"
 2) "2"
 3) "3"
 4) "4"
 5) "5"
 6) "6"
 7) "7"
 8) "8"
 9) "9"
10) "10"
11) "11"
12) "12"
13) "13"
14) "14"



##############################################################################


```







### Hash（哈希）





```bash
##############################################################################

127.0.0.1:6379> hset myhash field1 value1 #设置值 
(integer) 1
127.0.0.1:6379> hset myhash field2 value2 field3 value3 #可以同时设多个 
(integer) 2
127.0.0.1:6379> hget myhash field1
"value1" #获取一个字段值
127.0.0.1:6379> hget myhash field2 field3 #hget不能一次获取多个
(error) ERR wrong number of arguments for 'hget' command
127.0.0.1:6379> hmset hash1 f1 v1 f2 v2 f3 v3 #批处理，一次设置多个值
OK
127.0.0.1:6379> hmget myhash field1 field2 #批处理，一次获取多个值 
1) "value1"
2) "value2"
127.0.0.1:6379> hmget hash1 f1 f2 #批处理，一次获取多个值 
1) "v1"
2) "v2"
127.0.0.1:6379> hgetall myhash #获取全部的数据，获取所有键值对
1) "field1"
2) "value1"
3) "field2"
4) "value2"
5) "field3"
6) "value3"
127.0.0.1:6379> hgetall hash1 #获取全部的数据
1) "f1"
2) "v1"
3) "f2"
4) "v2"
5) "f3"
6) "v3"
127.0.0.1:6379> hdel hash1 f1 f3 #删除指定hash里一个或多个指定的字段
(integer) 2
127.0.0.1:6379> hgetall hash1 #获取全部的数据
1) "f2"
2) "v2"


##############################################################################

127.0.0.1:6379> hlen myhash #获取该哈希的字段数
(integer) 3
127.0.0.1:6379> hgetall myhash
1) "field1"
2) "value1"
3) "field2"
4) "value2"
5) "field3"
6) "value3"




##############################################################################

127.0.0.1:6379> hgetall hash1
1) "f2"
2) "v2"
3) "f1"
4) "v1"
5) "f3"
6) "v3"
7) "f4"
8) "v4"
127.0.0.1:6379> hexists hash1 f1 #判断该hash表中该字段是否存在
(integer) 1
127.0.0.1:6379> hexists hash1 f4 #判断该hash表中该字段是否存在
(integer) 1
127.0.0.1:6379> hexists hash1 f5 #判断该hash表中该字段是否存在
(integer) 0
127.0.0.1:6379> hexists hash1 v1 #判断该hash表中该字段是否存在
(integer) 0




##############################################################################
#只获得所有的field
#只获得所有的value

127.0.0.1:6379> hgetall hash1
1) "f2"
2) "v2"
3) "f1"
4) "v1"
5) "f3"
6) "v3"
7) "f4"
8) "v4"
127.0.0.1:6379> hkeys hash1 #只获得所有的field
1) "f2"
2) "f1"
3) "f3"
4) "f4"
127.0.0.1:6379> hvals hash1 #只获得所有的value
1) "v2"
2) "v1"
3) "v3"
4) "v4"


##############################################################################

127.0.0.1:6379> hset hash1 f1 10 #设置初始值 10
(integer) 1
127.0.0.1:6379> hincrby hash1 f1 2 #值自增2
(integer) 12
127.0.0.1:6379> hincrby hash1 f1 -5 #值自增-5，即自减5
(integer) 7
127.0.0.1:6379> hgetall hash1
1) "f1"
2) "7"
127.0.0.1:6379> hsetnx hash1 f2 v2 #如果不存在再设置
(integer) 1
127.0.0.1:6379> hgetall hash1
1) "f1"
2) "7"
3) "f2"
4) "v2"
127.0.0.1:6379> hsetnx hash1 f2 v3 #如果不存在再设置
(integer) 0
127.0.0.1:6379> hgetall hash1
1) "f1"
2) "7"
3) "f2"
4) "v2"


```







### Zset（有序集合）

在set的基础上，加了一个值

```bash
##############################################################################

127.0.0.1:6379> zadd zset1 1 one #添加一个值，1为"one"带的标签值，命令格式为 zadd key score value 
(integer) 1
127.0.0.1:6379> zadd zset1 2 two 3 three #可以一次添加多个
(integer) 2
127.0.0.1:6379> zrange zset1 0 -1 #查看所有值
1) "one"
2) "two"
3) "three"






##############################################################################

127.0.0.1:6379> zadd zset1 1000 my #添加一个值，1000为"my"带的标签值，命令格式为 zadd key score value
(integer) 1
127.0.0.1:6379> zadd zset1 500 you #添加一个值
(integer) 1
127.0.0.1:6379> zadd zset1 2000 her #添加一个值
(integer) 1
127.0.0.1:6379> zadd zset1 1500 him #添加一个值
(integer) 1
127.0.0.1:6379> zrangebyscore zset1 -inf +inf  #根据score值升序遍历，score值的范围为-inf到+inf，即负无穷到正无穷
1) "you"
2) "my"
3) "him"
4) "her"
127.0.0.1:6379> zrangebyscore zset1 -inf +inf withscores  #根据score值升序遍历，score值的范围为-inf到+inf，即负无穷到正无穷，打印带上score值
1) "you"
2) "500"
3) "my"
4) "1000"
5) "him"
6) "1500"
7) "her"
8) "2000"
127.0.0.1:6379> zrangebyscore zset1 -inf 1500 withscores  #根据score值升序遍历，score值的范围为-inf到1500，即负无穷到1500，打印带上score值
1) "you"
2) "500"
3) "my"
4) "1000"
5) "him"
6) "1500"
127.0.0.1:6379> zrangebyscore zset1 (500 (1500 withscores  #根据score值升序遍历，score值的范围为(500,1500)，即500到1500，左右开区间，打印带上score值
1) "my"
2) "1000"







##############################################################################

127.0.0.1:6379> zrevrange zset1 0 -1  #降序遍历
1) "her"
2) "him"
3) "my"
4) "you"
127.0.0.1:6379> zrevrange zset1 0 -1 withscores #降序遍历，带上score值
1) "her"
2) "2000"
3) "him"
4) "1500"
5) "my"
6) "1000"
7) "you"
8) "500"
127.0.0.1:6379> zrevrangebyscore zset1 +inf -inf withscores  #降序遍历，score值的范围为+inf至-inf，带上score值
1) "her"
2) "2000"
3) "him"
4) "1500"
5) "my"
6) "1000"
7) "you"
8) "500"



##############################################################################

127.0.0.1:6379> zrange zset1 0 -1 #查看值
1) "you"
2) "my"
3) "him"
4) "her"
127.0.0.1:6379> zrem zset1 my #移除值
(integer) 1
127.0.0.1:6379> zrange zset1 0 -1 #查看值
1) "you"
2) "him"
3) "her"
127.0.0.1:6379> zrem zset1 you him #可以一次移除多个
(integer) 2
127.0.0.1:6379> zrange zset1 0 -1 #查看值
1) "her"

##############################################################################

127.0.0.1:6379> zrange zset1 0 -1 #查看值
1) "my"
2) "her"
127.0.0.1:6379> zcard zset1 #查看总个数 
(integer) 2

##############################################################################

127.0.0.1:6379> zrange zset1 0 -1 withscores #查看值
1) "you"
2) "500"
3) "my"
4) "1000"
5) "him"
6) "1500"
7) "her"
8) "2000"
127.0.0.1:6379> zcount zset1 500 1500 #统计集合zset1的score值在区间[500,1500]的元素个数
(integer) 3


```









## 三种特殊数据类型

### geospatial 地理位置



```bash
##############################################################################

#geoadd key longitude latitude member [longitude latitude member ...]
127.0.0.1:6379> geoadd china:city 116.23128 40.22077 beijing #添加值（可同时添加多个），china:city为key，116.23128是经度，40.22077是纬度，beijing是元素名称
(integer) 1
127.0.0.1:6379> geoadd china:city 113.27324 23.15792 guangzhou 121.48941 31.40527 shanghai
(integer) 2
#geopos key member [member ...]
127.0.0.1:6379> geopos china:city beijing #查看对应的元素的经度与纬度
1) 1) "116.23128265142440796"
   2) "40.22076905438526495"
127.0.0.1:6379> geopos china:city guangzhou shanghai #查看对应的元素的经度与纬度，可以同时查询多个
1) 1) "113.27324062585830688"
   2) "23.1579209662846921"
2) 1) "121.48941010236740112"
   2) "31.40526993848380499"
#geodist key member1 member2 [m|km|ft|mi]
127.0.0.1:6379> geodist china:city beijing shanghai km #计算两地的距离，单位为千米
"1088.6444"
127.0.0.1:6379> geodist china:city beijing shanghai m #计算两地的距离，单位为米
"1088644.3544"
127.0.0.1:6379> geodist china:city beijing shanghai  #计算两地的距离，单位为米（默认值）
"1088644.3544"
127.0.0.1:6379> geodist china:city beijing shanghai ft #计算两地的距离，单位为英尺
"3571667.8295"
127.0.0.1:6379> geodist china:city beijing shanghai mi #计算两地的距离，单位为英里
"676.4539"
#以给定的经纬度为中心，找出某一半径内的元素
#georadius key longitude latitude radius m|km|ft|mi [WITHCOORD] [WITHDIST] [WITHHASH] [COUNT count] [ASC|DESC] [STORE key] [STOREDIST key]
127.0.0.1:6379> georadius china:city 110 38 1000 km #以给定的经纬度(110,38)为中心，找出指定key(china:city)中满足在某一半径内(1000km)的元素
1) "beijing"
127.0.0.1:6379> georadius china:city 110 38 1500 km
1) "shanghai"
2) "beijing"
127.0.0.1:6379> georadius china:city 110 38 2000 km
1) "guangzhou"
2) "shanghai"
3) "beijing"
127.0.0.1:6379> georadius china:city 110 38 1500 km withcoord
1) 1) "shanghai"
   2) 1) "121.48941010236740112"
      2) "31.40526993848380499"
2) 1) "beijing"
   2) 1) "116.23128265142440796"
      2) "40.22076905438526495"
127.0.0.1:6379> georadius china:city 110 38 1500 km withdist
1) 1) "shanghai"
   2) "1279.6978"
2) 1) "beijing"
   2) "591.6114"
127.0.0.1:6379> georadius china:city 110 38 2000 km withdist
1) 1) "guangzhou"
   2) "1679.9840"
2) 1) "shanghai"
   2) "1279.6978"
3) 1) "beijing"
   2) "591.6114"
127.0.0.1:6379> georadius china:city 110 38 2000 km withdist count 2 #count 2 限制个数为2个
1) 1) "beijing"
   2) "591.6114"
2) 1) "shanghai"
   2) "1279.6978"
127.0.0.1:6379> georadiusbymember china:city beijing 1500 km withdist #以某一个元素作为定位中心
1) 1) "shanghai"
   2) "1088.6444"
2) 1) "beijing"
   2) "0.0000"

#geo的底层是zset
127.0.0.1:6379> zrange china:city 0 -1
1) "guangzhou"
2) "shanghai"
3) "beijing"
127.0.0.1:6379> zrem china:city shanghai
(integer) 1
127.0.0.1:6379> zrange china:city 0 -1
1) "guangzhou"
2) "beijing"
127.0.0.1:6379> geopos china:city beijing guangzhou shanghai
1) 1) "116.23128265142440796"
   2) "40.22076905438526495"
2) 1) "113.27324062585830688"
   2) "23.1579209662846921"
3) (nil)



```









### hyperloglog 

用于基数统计，不保存具体数据

优点：占用的内存是固定的，只需要12KB内存

存在0.81%的错误率

```bash
##############################################################################


127.0.0.1:6379> pfadd mykey a b c d e f g c #把 a b c d e f g 加入集合（最后一个重复的c无效），有7个元素
(integer) 1
127.0.0.1:6379> pfcount mykey #统计集合的基数，即不重复的元素的个数
(integer) 7
127.0.0.1:6379> pfadd mykey1 a b c d e f g h #把 a b c d e f g h 加入集合，有8个元素
(integer) 1
127.0.0.1:6379> pfcount mykey mykey1  #统计集合mykey与mykey1的并集的基数
(integer) 8
127.0.0.1:6379> pfmerge mykey2 mykey mykey1 #把集合mykey与mykey1的并集保存到集合mykey2
OK
127.0.0.1:6379> keys *
1) "mykey"
2) "mykey2"
3) "mykey1"
127.0.0.1:6379> pfcount mykey2 #统计集合mykey2的基数
(integer) 8

```







### bitmaps

> 位存储，两个状态的，都可以使用bitmaps

```bash
##############################################################################


#setbit key offset value
127.0.0.1:6379> setbit bitmaps1 0 1 #设置第一位为1
(integer) 0
127.0.0.1:6379> setbit bitmaps1 1 2 #这里的value值不是0或1，所以报错
(error) ERR bit is not an integer or out of range
127.0.0.1:6379> setbit bitmaps1 1 0 #设置第二位为0，后面以此类推
(integer) 0
127.0.0.1:6379> setbit bitmaps1 2 0
(integer) 0
127.0.0.1:6379> setbit bitmaps1 3 0
(integer) 0
127.0.0.1:6379> setbit bitmaps1 4 1 #也可以隔空设置，不设置的默认为0
(integer) 0
127.0.0.1:6379> setbit bitmaps1 5 1
(integer) 0
127.0.0.1:6379> setbit bitmaps1 6 0
(integer) 0
127.0.0.1:6379> setbit bitmaps1 7 1
(integer) 0
127.0.0.1:6379> setbit bitmaps1 8 1
(integer) 0
127.0.0.1:6379> setbit bitmaps1 9 1
(integer) 0
127.0.0.1:6379> setbit bitmaps1 10 0 #设置第11位为0
(integer) 0
#getbit key offset
127.0.0.1:6379> getbit bitmaps1 1 #获取第二位的值
(integer) 0
127.0.0.1:6379> getbit bitmaps1 4 #获取第五位的值
(integer) 1
127.0.0.1:6379> getbit bitmaps1 10 #获取第11位的值
(integer) 0
#统计数量，获得位为1的数量
#bitcount key [start end]
127.0.0.1:6379> bitcount bitmaps1 #总共有6位，011 1011 0001  ，这里是左高位，[start end]参数中，011为下标1 ， 10110001为下标0
(integer) 6
127.0.0.1:6379> bitcount bitmaps1 0 0 #其中在0位Byte的位是 10110001
(integer) 4
127.0.0.1:6379> bitcount bitmaps1 1 1  #其中在1位Byte的位是 011
(integer) 2



```







## 事务

一次性、顺序性、排他性

**redis单条命令保证原子性，但事务不保证原子性**

**redis没有隔离级别的概念**

锁：redis可以实现乐观锁

redis的事务：

- 开启事务(multi)

- 命令入队(...)

- 执行事务(exec)

- 例子

  ```bash
  
  127.0.0.1:6379> multi #开启事务
  OK
  #命令入队
  127.0.0.1:6379> set k1 v1
  QUEUED
  127.0.0.1:6379> get k1
  QUEUED
  127.0.0.1:6379> get k2
  QUEUED
  127.0.0.1:6379> set k2 v2
  QUEUED
  127.0.0.1:6379> get k2
  QUEUED
  127.0.0.1:6379> set k3 v3 
  QUEUED
  127.0.0.1:6379> exec #执行事务
  1) OK
  2) "v1"
  3) (nil)
  4) OK
  5) "v2"
  6) OK
  
  ##############################################################################
  #运行时异常，不保证事务的原子性，
  
  
  127.0.0.1:6379> set k1 v1
  OK
  127.0.0.1:6379> multi
  OK
  127.0.0.1:6379> incr k1 #错误的命令，字符串不能自增，导致运行时异常
  QUEUED
  127.0.0.1:6379> set k2 v2
  QUEUED
  127.0.0.1:6379> exec
  1) (error) ERR value is not an integer or out of range
  2) OK
  
  
  ##############################################################################
  #编译型异常，事务中所有的命令都不会被执行
  
  127.0.0.1:6379> multi
  OK
  127.0.0.1:6379> set k1 v1
  QUEUED
  127.0.0.1:6379> set k2 #导致编译时异常
  (error) ERR wrong number of arguments for 'set' command
  127.0.0.1:6379> set k3 v3
  QUEUED
  127.0.0.1:6379> exec #事务全部失败
  (error) EXECABORT Transaction discarded because of previous errors.
  127.0.0.1:6379> get k1
  (nil)
  127.0.0.1:6379> get k3
  (nil)
  
  
  ##############################################################################
  #放弃事务discard
  127.0.0.1:6379> multi
  OK
  127.0.0.1:6379> set k7 v7
  QUEUED
  127.0.0.1:6379> discard #放弃事务，队列中的命令都无效了
  OK
  127.0.0.1:6379> get k7
  (nil)
  
  ```

  

实现乐观锁

> redis监视

```bash
##############################################################################
#正常情况
127.0.0.1:6379> set money 100
OK
127.0.0.1:6379> set out 0
OK
127.0.0.1:6379> watch money #监控money
OK
127.0.0.1:6379> multi
OK
127.0.0.1:6379> decrby money 20
QUEUED
127.0.0.1:6379> incrby out 20
QUEUED
127.0.0.1:6379> exec #事务执行成功后监控就失效了
1) (integer) 80
2) (integer) 20

##############################################################################
#失败的情况

#客户端1
127.0.0.1:6379> get money
"80"
127.0.0.1:6379> get out
"20"
127.0.0.1:6379> watch money
OK
127.0.0.1:6379> multi
OK
127.0.0.1:6379> decrby money 20
QUEUED
127.0.0.1:6379> incrby out 20
QUEUED
#这里还没有提交执行

#客户端2
127.0.0.1:6379> get money
"80"
127.0.0.1:6379> set money 10000 #修改了money
OK
127.0.0.1:6379> get money
"10000"

#客户端1
127.0.0.1:6379> exec #执行失败，因为监控的money发生了改变
(nil)
127.0.0.1:6379> get money
"10000"

127.0.0.1:6379> unwatch #放弃锁
OK


```





## Jedis

1. 导包

   ```xml
   <!--jedis-->
   <!-- https://mvnrepository.com/artifact/redis.clients/jedis -->
   <dependency>
       <groupId>redis.clients</groupId>
       <artifactId>jedis</artifactId>
       <version>3.4.0</version>
   </dependency>
   ```

2. 如果是远程的，需要防火墙开放对应端口号，同时修改配置文件（为了安全最好加上连接密码）

   1. 防火墙开放对应端口号（针对自己的服务器的方法解决）

   2. 修改配置文件

      - 允许远程连接

        ![image-20201215151906122](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201215151906122.png)

      - 添加连接密码

        ![image-20201215152111062](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201215152111062.png)

3. 代码测试

   ![image-20201215152346094](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201215152346094.png)

   ```java
   public class TestPing {
       public static void main(String[] args) {
           //1.new 对象
           Jedis jedis = new Jedis("服务器ip",6379);
           //2.连接密码
           jedis.auth("123456");
           //3.测试连接
           System.out.println(jedis.ping());//PONG
           jedis.set("k1","测试中文");
           System.out.println(jedis.get("k1"));//测试中文
       }
   }
   ```

   



## SpringBoot整合

1.  引入依赖

   ```xml
   <!--redis-->
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-data-redis</artifactId>
   </dependency>
   ```

2. 配置属性（如果有需要）

   ```yaml
   spring:
     redis:
       host: 127.0.0.1
       port: 6379
       password: 123456
   ```

3. 自定义模板（如果有需要）

   ```java
   @Configuration
   public class RedisConfig {
   
       /**
        * 自定义RedisTemplate 模板
        * @param redisConnectionFactory
        * @return
        */
       @Bean
       @SuppressWarnings("all") //压制警告
       public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory redisConnectionFactory) {
   
           RedisTemplate<String, Object> template = new RedisTemplate<>();
           template.setConnectionFactory(redisConnectionFactory);
   
           Jackson2JsonRedisSerializer<Object> objectJackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer<>(Object.class);
           ObjectMapper om = new ObjectMapper();
           om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
           om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);//springboot2.4.0中方法过期了
           objectJackson2JsonRedisSerializer.setObjectMapper(om);
           
           StringRedisSerializer stringRedisSerializer = new StringRedisSerializer();
   
           //配置具体的序列化方式
           //key使用string的序列化方式
           template.setKeySerializer(stringRedisSerializer);
           //hash的key使用string的序列化方式
           template.setHashKeySerializer(stringRedisSerializer);
           //value使用jackson的序列化方式
           template.setValueSerializer(objectJackson2JsonRedisSerializer);
           //hash的value使用jackson的序列化方式
           template.setHashValueSerializer(objectJackson2JsonRedisSerializer);
           template.afterPropertiesSet();
   
           return template;
       }
   
   
   }
   ```

4. 对模板的封装（如果有需要）

   ```java
   @Component
   public final class RedisUtil {
   
       @Autowired
       private RedisTemplate<String,Object> redisTemplate;
   
       //封装具体的操作代码
       
   }
   ```

5. 实体类需要序列化（实现Serializable接口）

   ```java
   @Data
   @AllArgsConstructor
   @NoArgsConstructor
   //实现Serializable接口
   public class User implements Serializable {
       private String name;
       private Integer age;
   }
   ```

6. 测试





## redis.conf详解







## redis持久化









## redis发布订阅











## redis主从复制









## redis缓存穿透和雪崩









