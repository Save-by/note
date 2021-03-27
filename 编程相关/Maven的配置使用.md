# Maven的配置使用

> 仅个人笔记
>
> 可以直接跳到1. Maven 的安装

>Maven 翻译为"专家"、"内行"，是 Apache 下的一个纯 Java 开发的开源项目。基于项目对象模型（缩写：POM）概念，Maven利用一个中央信息片断能管理一个项目的构建、报告和文档等步骤。
>
>Maven 是一个项目管理工具，可以对 Java 项目进行构建、依赖管理。
>
>Maven 也可被用于构建和管理各种项目，例如 C#，Ruby，Scala 和其他语言编写的项目。Maven 曾是 Jakarta 项目的子项目，现为由 Apache 软件基金会主持的独立 Apache 项目。

## 一、介绍

### Maven 功能

Maven 能够帮助开发者完成以下工作：

- 构建
- 文档生成
- 报告
- 依赖
- SCMs
- 发布
- 分发
- 邮件列表

### 约定配置

Maven 提倡使用一个共同的标准目录结构，Maven 使用约定优于配置的原则，大家尽可能的遵守这样的目录结构。如下所示：

| 目录                               | 目的                                                         |
| :--------------------------------- | :----------------------------------------------------------- |
| ${basedir}                         | 存放pom.xml和所有的子目录                                    |
| ${basedir}/src/main/java           | 项目的java源代码                                             |
| ${basedir}/src/main/resources      | 项目的资源，比如说property文件，springmvc.xml                |
| ${basedir}/src/test/java           | 项目的测试类，比如说Junit代码                                |
| ${basedir}/src/test/resources      | 测试用的资源                                                 |
| ${basedir}/src/main/webapp/WEB-INF | web应用文件目录，web项目的信息，比如存放web.xml、本地图片、jsp视图页面 |
| ${basedir}/target                  | 打包输出目录                                                 |
| ${basedir}/target/classes          | 编译输出目录                                                 |
| ${basedir}/target/test-classes     | 测试编译输出目录                                             |
| Test.java                          | Maven只会自动运行符合该命名规则的测试类                      |
| ~/.m2/repository                   | Maven默认的本地仓库目录位置                                  |



### Maven 特点

- 项目设置遵循统一的规则。
- 任意工程中共享。
- 依赖管理包括自动更新。
- 一个庞大且不断增长的库。
- 可扩展，能够轻松编写 Java 或脚本语言的插件。
- 只需很少或不需要额外配置即可即时访问新功能。
- **基于模型的构建** − Maven能够将任意数量的项目构建到预定义的输出类型中，如 JAR，WAR 或基于项目元数据的分发，而不需要在大多数情况下执行任何脚本。
- **项目信息的一致性站点** − 使用与构建过程相同的元数据，Maven 能够生成一个网站或PDF，包括您要添加的任何文档，并添加到关于项目开发状态的标准报告中。
- **发布管理和发布单独的输出** − Maven 将不需要额外的配置，就可以与源代码管理系统（如 Subversion 或 Git）集成，并可以基于某个标签管理项目的发布。它也可以将其发布到分发位置供其他项目使用。Maven 能够发布单独的输出，如 JAR，包含其他依赖和文档的归档，或者作为源代码发布。
- **向后兼容性** −  您可以很轻松的从旧版本 Maven 的多个模块移植到 Maven 3 中。
- 子项目使用父项目依赖时，正常情况子项目应该继承父项目依赖，无需使用版本号，
- **并行构建** − 编译的速度能普遍提高20 - 50 %。
- **更好的错误报告** − Maven 改进了错误报告，它为您提供了 Maven wiki 页面的链接，您可以点击链接查看错误的完整描述。



## 二、环境配置

Maven 是一个基于 Java 的工具，所以要做的第一件事情就是安装 JDK。

### 系统要求

| 项目     | 要求                                                         |
| :------- | :----------------------------------------------------------- |
| JDK      | Maven 3.3 要求 JDK 1.7 或以上 Maven 3.2 要求 JDK 1.6 或以上 Maven 3.0/3.1 要求 JDK 1.5 或以上 |
| 内存     | 没有最低要求                                                 |
| 磁盘     | Maven 自身安装需要大约 10 MB 空间。除此之外，额外的磁盘空间将用于你的本地 Maven 仓库。你本地仓库的大小取决于使用情况，但预期至少 500 MB |
| 操作系统 | 没有最低要求                                                 |

### 检查 Java 安装

| 操作系统 | 任务           | 命令                 |
| :------- | :------------- | :------------------- |
| Windows  | 打开命令控制台 | `c:\> java -version` |
| Linux    | 打开命令终端   | `# java -version`    |
| Mac      | 打开终端       | `$ java -version`    |

### Maven 下载

Maven 下载地址：http://maven.apache.org/download.cgi

（英文看不到可以谷歌机翻一下嘛对不对）

![img](https://www.runoob.com/wp-content/uploads/2018/09/750D721E-0624-4C16-AD4B-9EA5D7F6289A.png)

不同平台下载对应的包：



|  系统   |             包名              |
| :-----: | :---------------------------: |
| Windows |  apache-maven-3.3.9-bin.zip   |
|  Linux  | apache-maven-3.3.9-bin.tar.gz |
|   Mac   | apache-maven-3.3.9-bin.tar.gz |

下载包后解压到对应目录：

|  系统   | 存储位置 (可根据自己情况配置) |
| :-----: | :---------------------------- |
| Windows | E:\Maven\apache-maven-3.3.9   |
|  Linux  | /usr/local/apache-maven-3.3.9 |
|   Mac   | /usr/local/apache-maven-3.3.9 |

（下面的是2020/7截的图）

![image-20200729212000391](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20200729212000391.png)

### 设置 Maven 环境变量 

添加环境变量 MAVEN_HOME：

1. windows

   右键 "计算机"，选择 "属性"，之后点击 "高级系统设置"，点击"环境变量"，来设置环境变量，有以下系统变量需要配置：

   新建系统变量 **MAVEN_HOME**，变量值：**E:\Maven\apache-maven-3.3.9**

   

   ![img](https://www.runoob.com/wp-content/uploads/2018/09/1536057115-1481-20151218175411912-170761788.png)

   编辑系统变量 **Path**，添加变量值：**;%MAVEN_HOME%\bin**

   ![img](https://www.runoob.com/wp-content/uploads/2018/09/1536057115-7470-20151218175417006-1644078150.png)

   **注意：**注意多个值之间需要有分号隔开，然后点击确定。

   

2. Linux

   下载解压：

   ```sh
   # wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
   # tar -xvf  apache-maven-3.3.9-bin.tar.gz
   # sudo mv -f apache-maven-3.3.9 /usr/local/
   ```

   编辑 **/etc/profile** 文件 **sudo vim /etc/profile**，在文件末尾添加如下代码：

   ```sh
   export MAVEN_HOME=/usr/local/apache-maven-3.3.9
   export PATH=${PATH}:${MAVEN_HOME}/bin
   ```

   保存文件，并运行如下命令使环境变量生效：

   ```sh
   source /etc/profile
   ```

   在控制台输入如下命令，如果能看到 Maven 相关版本信息，则说明 Maven 已经安装成功：

   ```sh
   # mvn -v
   ```

   

3. Mac

   下载解压：

   ```sh
   $ curl -O http://mirrors.hust.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
   $ tar -xvf  apache-maven-3.3.9-bin.tar.gz
   $ sudo mv -f apache-maven-3.3.9 /usr/local/
   ```

   编辑 **/etc/profile** 文件 **sudo vim /etc/profile**，在文件末尾添加如下代码：

   ```sh
   export MAVEN_HOME=/usr/local/apache-maven-3.3.9
   export PATH=${PATH}:${MAVEN_HOME}/bin
   ```

   保存文件，并运行如下命令使环境变量生效：

   ```sh
   $ source /etc/profile
   ```

   在控制台输入如下命令，如果能看到 Maven 相关版本信息，则说明 Maven 已经安装成功：

   ```sh
   $ mvn -v
   Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-11T00:41:47+08:00)
   Maven home: /usr/local/apache-maven-3.3.9
   Java version: 1.8.0_31, vendor: Oracle Corporation
   Java home: /Library/Java/JavaVirtualMachines/jdk1.8.0_31.jdk/Contents/Home/jre
   Default locale: zh_CN, platform encoding: ISO8859-1
   OS name: "mac os x", version: "10.13.4", arch: "x86_64", family: "mac"
   ```



## 三、Maven POM

POM( Project Object Model，项目对象模型 ) 是 Maven 工程的基本工作单元，是一个XML文件，包含了项目的基本信息，用于描述项目如何构建，声明项目依赖，等等。

执行任务或目标时，Maven 会在当前目录中查找 POM。它读取 POM，获取所需的配置信息，然后执行目标。

**POM 中可以指定以下配置**：

- 项目依赖
- 插件
- 执行目标
- 项目构建 profile
- 项目版本
- 项目开发者列表
- 相关邮件列表信息



在创建 POM 之前，我们首先需要描述项目组 (groupId), 项目的唯一ID。

```xml
<project xmlns = "http://maven.apache.org/POM/4.0.0"
    xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation = "http://maven.apache.org/POM/4.0.0
    http://maven.apache.org/xsd/maven-4.0.0.xsd">
 
    <!-- 模型版本 -->
    <modelVersion>4.0.0</modelVersion>
    <!-- 公司或者组织的唯一标志，并且配置时生成的路径也是由此生成， 如com.companyname.project-group，maven会将该项目打成的jar包放本地路径：/com/companyname/project-group -->
    <groupId>com.companyname.project-group</groupId>
 
    <!-- 项目的唯一ID，一个groupId下面可能多个项目，就是靠artifactId来区分的 -->
    <artifactId>project</artifactId>
 
    <!-- 版本号 -->
    <version>1.0</version>
</project
```

所有 POM 文件都需要 project 元素和三个必需字段：groupId，artifactId，version。

| 节点         | 描述                                                         |
| :----------- | :----------------------------------------------------------- |
| project      | 工程的根标签。                                               |
| modelVersion | 模型版本需要设置为 4.0。                                     |
| groupId      | 这是工程组的标识。它在一个组织或者项目中通常是唯一的。例如，一个银行组织 com.companyname.project-group 拥有所有的和银行相关的项目。 |
| artifactId   | 这是工程的标识。它通常是工程的名称。例如，消费者银行。groupId 和 artifactId 一起定义了 artifact 在仓库中的位置。 |
| version      | 这是工程的版本号。在 artifact 的仓库中，它用来区分不同的版本。例如： <br />com.company.bank:consumer-banking:1.0 <br />com.company.bank:consumer-banking:1.1 |



### 父（Super）POM

父（Super）POM是 Maven 默认的 POM。所有的 POM 都继承自一个父 POM（无论是否显式定义了这个父 POM）。父 POM 包含了一些可以被继承的默认设置。因此，当 Maven 发现需要下载 POM 中的 依赖时，它会到 Super POM 中配置的默认仓库 http://repo1.maven.org/maven2 去下载。

Maven 使用 effective pom（Super pom 加上工程自己的配置）来执行相关的目标，它帮助开发者在 pom.xml 中做尽可能少的配置，当然这些配置可以被重写。

使用以下命令来查看 Super POM 默认配置：

```sh
mvn help:effective-pom
```



*（搬运先截止于此，很抱歉很抱歉，但直接拉过来好像也不是很好哈哈哈，上面的也懒得删了）*

> 附上来源：菜鸟教程：https://www.runoob.com/maven/maven-tutorial.html



## 1. Maven 的安装

1. 配置环境

2. 修改 maven 中的 setting 文件

   1. 本地仓库位置的位置的修改

      ![image-20200729224453628](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20200729224453628.png)

   2. 中央仓库的修改

      ![image-20200729224535979](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20200729224535979.png)

## 2. idea中maven的配置

打开IDEA 选择File——Settings

![image-20200729234634782](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20200729234634782.png)



## 3. Maven 的使用

### maven的jar包仓库管理

一个maven项目，它的项目里是没有jar包的，它存放的是jar包的地址，当需要用到jar包的时候，就会回去jar包仓库中找对应的jar包。这也是maven项目比普通项目大小要小得多的原因。



### 在idea中maven的使用

1. 直接新建一个项目

2. 选择maven（可以利用选项create from archetype 快速创建webapp）

3. 起名字（GroupId,ArtifactId,Version）

4. 指定maven目录，配置文件以及本地仓库位置

5. 指定项目的名称和位置

6. 补成标准目录结构

   ```
   src
   	main 
   		java
   		resources
   		webapp
   	test 
   		java
   		resources
   target
   ```

   - **src** 目录是源代码和测试代码的根目录。 
     - main 目录是与源代码相关的根目录到应用程序本身，而不是测试代码。 

     - **test** 目录包含测试源代码。 
     - main和test下的 java 目录分别包含Java代码的应用程序本身和用于测试的Java代码。 

     - **resources** 目录包含您项目所需的资源。 
   -  **target** 目录由Maven创建。它包含所有编译的类，JAR文件等。 
      当执行 mvn clean 命令时，Maven将清除目标目录。 
   - **webapp** 目录包含Java Web应用程序，如果项目是Web应用程序。 
      webapp 目录是Web应用程序的根目录。webapp目录包含 WEB-INF 目录。 
      如果按照目录结构，你不需要指定你的源代码的目录，测试代码，资源文件等。





> 参考菜鸟教程：https://www.runoob.com/maven/maven-tutorial.html