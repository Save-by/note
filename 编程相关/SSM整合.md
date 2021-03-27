# SSM整合

> 仅个人笔记
>
> （有想知道详细的可以转https://blog.csdn.net/qq_44543508/article/details/100192558）



## 一、搭建整合环境

### 整合说明

使用xml + 注解的方式

### 思路

1. 搭建整合的环境

2. 把Spring的配置搭建完成

3. 使用Spring整合SpringMVC框架   

4. 使用Spring整合MyBatis框架

5. spring整合mybatis框架配置事务（Spring的声明式事务管理）

6. 项目目录

   ![image-20200813110238181](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20200813110238181.png)

### POM环境

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.by</groupId>
    <artifactId>ssmTest</artifactId>
    <version>1.0-SNAPSHOT</version>

    <!--依赖-->
    <dependencies>

        <!--jinit-->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13</version>
            <scope>test</scope>
        </dependency>

        <!--mysql-->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.21</version>
        </dependency>

        <!--数据库连接池-->
        <dependency>
            <groupId>com.mchange</groupId>
            <artifactId>c3p0</artifactId>
            <version>0.9.5.2</version>
        </dependency>


        <!--servlet - jsp-->
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.2</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>

        <!--mybatis-->
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.5</version>
        </dependency>
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>2.0.5</version>
        </dependency>

        <!--spring-->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.2.8.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>5.2.8.RELEASE</version>
        </dependency>

        <!--Lombok-->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.12</version>
        </dependency>
        
    </dependencies>

    <!--静态资源导出问题-->
    <build>
        <resources>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>false</filtering>
            </resource>
            <resource>
                <directory>src/main/resources</directory>
                <includes>
                    <include>**/*.properties</include>
                    <include>**/*.xml</include>
                </includes>
                <filtering>false</filtering>
            </resource>
        </resources>
    </build>

</project>
```

### 建库建表

```sql
CREATE DATABASE /*!32312 IF NOT EXISTS*/`ssmbuild` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ssmbuild`;

/*Table structure for table `t_book` */

DROP TABLE IF EXISTS `t_book`;

CREATE TABLE `t_book` (
  `bookId` int NOT NULL AUTO_INCREMENT COMMENT '书id',
  `bookName` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '书名',
  `bookCount` int NOT NULL COMMENT '数量',
  `detail` varchar(255) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`bookId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `t_book` */

insert  into `t_book`(`bookId`,`bookName`,`bookCount`,`detail`) values (1,'Java',1,'入门'),(2,'python',5,'进阶'),(3,'sql',4,'删库');
```

### 创建maven工程

（略：）

### 创建实体类

```java
package com.by.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Book {
    private Integer bookId;
    private String bookName;
    private Integer bookCount;
    private String detail;

}
```

### 创建dao接口

````java
package com.by.mapper;

import com.by.pojo.Book;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BookMapper {
    
    int insert(Book book);

    int delete(@Param("bookId") int id);

    int update(Book book);

    Book selectOne(@Param("bookId")int id);

    List<Book> selectAll();
}
````

### 创建service接口和实现类

```java
//为了方便
//接口
public interface BookService {
    
    int insert(Book book);

    int delete( int id);

    int update(Book book);

    Book selectOne(int id);

    List<Book> selectAll();
}

//-----------------------------------------------
//实现类
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookServiceImpl implements BookService{

    @Autowired
    private BookMapper bookMapper;

    public BookMapper getBookMapper() {
        return bookMapper;
    }

    public void setBookMapper(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    public int insert(Book book) {
        return bookMapper.insert(book);
    }

    public int delete(int id) {
        return bookMapper.delete(id);
    }

    public int update(Book book) {
        return bookMapper.update(book);
    }

    public Book selectOne(int id) {
        return bookMapper.selectOne(id);
    }

    public List<Book> selectAll() {
        return bookMapper.selectAll();
    }
}
```

### 创建controller

```java
package com.by.controller;

import com.by.pojo.Book;
import com.by.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/book")
public class BookController {

    @Autowired
    private BookService bookService;

    //查询全部
    @RequestMapping("allBook")
    public String list(Model model){
        List<Book> list = bookService.selectAll();

        model.addAttribute("list",list);

        return "allBook";
    }

}
```

## 二、mybatis编写

根配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">

<!--mybatis的主配置文件-->
<configuration>

    <typeAliases>
        <package name="com.by.pojo"/>
    </typeAliases>
    
    <!--指定映射配置文件的位置，映射配置文件是指每一个dao独立的配置文件-->
    <mappers>
        <package name="com.by.mapper"/>
        <!--<mapper resource="com/by/mapper/BookMapper.xml" />-->
    </mappers>
</configuration>
```

对应的mapper的配置文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<!--mybatis的分配置文件-->
<mapper namespace="com.by.mapper.BookMapper">

    <insert id="insert" parameterType="Book">
        insert into t_book (bookName,bookCount,detail)
        values (#{bookName},#{bookCount},#{detail})
    </insert>

    <delete id="delete" parameterType="int" >
        delete from t_book where bookId = #{bookId}
    </delete>

    <update id="update" parameterType="Book">
        update t_book
        set bookName=#{bookName},bookCount=#{bookCount},detail=#{detail}
        where bookId=#{bookId}
    </update>

    <select id="selectOne" resultType="Book">
        select * from t_book
        where bookId=#{bookId}
    </select>

    <select id="selectAll" resultType="Book">
        select * from t_book
    </select>

</mapper>
```

## 三、spring整合mybatis

spring-dao.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">

    <!--1.关联数据库配置文件-->
    <context:property-placeholder location="classpath:jdbc.properties" />

    <!--2.连接池-->
    <bean id="dataSource" class="com.mchange.v2.c3p0.ComboPooledDataSource">
        <property name="driverClass" value="${db.driver}" />
        <property name="jdbcUrl" value="${db.url}" />
        <property name="user" value="${db.username}" />
        <property name="password" value="${db.password}" />
    </bean>



    <!--3.sqlSessionFactory-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource" />

        <!--绑定mybatis的配置文件-->
        <property name="configLocation" value="classpath:mybatis-config.xml" />
    </bean>

    <!--配置dao接口扫描包-->
    <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
        <!--注入-->
        <property name="sqlSessionFactoryBeanName" value="sqlSessionFactory" />
        <!--要扫描的dao包-->
        <property name="basePackage" value="com.by.mapper" />
    </bean>

</beans>
```

jdbc.properties

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/ssmbuild?serverTimezone=UTC
db.username=root
db.password=123456
```

## 四、spring配置事务

spring-service.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
    
    <!--扫描service包-->
    <context:component-scan base-package="com.by.service" />

    <!--将所有业务类，注入到spring(已经使用注解注入)-->

    <!--声明式事务配置-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager" >
        <property name="dataSource" ref="dataSource" />
    </bean>
    
</beans>
```

## 五、spring部分

applicationContext.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">

    <import resource="spring-dao.xml"/>
    <import resource="spring-service.xml" />
    <import resource="spring-mvc.xml" />

</beans>
```

## 六、springMVC 部分

spring-mvc.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
                           http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd">


    <!--注册驱动-->
    <mvc:annotation-driven />
    <!--静态资源过滤-->
    <mvc:default-servlet-handler />
    <!--扫描包-->
    <context:component-scan base-package="com.by.controller" />

    <!--配置视图解析器-->
    <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/view/" />
        <property name="suffix" value=".jsp" />
    </bean>
    
</beans>
```

web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">
    
    <!--配置mvc的核心控制器-->
    <servlet>
        <servlet-name>springMVC</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:applicationContext.xml</param-value>
        </init-param>
    </servlet>
    <servlet-mapping>
        <servlet-name>springMVC</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
    
    <!--设置字符集-->
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>utf-8</param-value>
        </init-param>
    </filter>

    <filter-mapping>
        <filter-name>encodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
        
</web-app>
```

## 七、测试

### 个人遇到的问题

1. 因为表的列名与实体类属性名命名不一致，又未起别名导致数据注入失败（idea显示的竟然是无法连接数据库！）

2. 在mybatis-config.xml里面（文件路径用点分就无法找到文件）（不过包路径可以用点分）

   ```xml
   <mappers>
       <!--<mapper resource="com.by.mapper.BookMapper.xml" />-->
       <mapper resource="com/by/mapper/BookMapper.xml" />
   </mappers>
   ```

3. 在spring-dao.xml中，ref="dataSource"不小心写成了value="dataSource"（不记得报的什么错了，也是跟视频才发现的）

   ```xml
   <!--3.sqlSessionFactory-->
   <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
       <property name="dataSource" ref="dataSource" />
   
       <!--绑定mybatis的配置文件-->
       <property name="configLocation" value="classpath:mybatis-config.xml" />
   </bean>
   ```

4. idea的生成的class文件没有自动包含maven依赖，需要手动添加lib包并添加maven依赖（不然直接404）

5. setting-》Build,Execution,Deployment-》Compiler-》Java Compiler里面的模块版本需要修改（太低不行，太高也不行，自己试试吧）