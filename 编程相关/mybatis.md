# mybatis

> 仅个人笔记

> mybatis是一个优秀的基于Java的持久层框架，内部封装了jdbc，使开发者只需要关注SQL语句本身，而无需关注注册驱动，创建连接等繁琐过程

## 一、入门

1. 三层架构

   1. 表现层
      - 展示数据

   2. 业务层
      - 业务处理

   3. 持久层
      - 与数据库交互



![image-20200804212449532](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20200804212449532.png)



2. 持久层技术解决方案

   1. jdbc
   2. Spring的JdbcTemplate
      - Spring中对jdbc的简单封装
   3. apache的DbUtils:
      - 对jdbc的简单封装
   4. （以上都不是框架）
      - jdbc是规范
      - JdbcTemplate与DbUtils都只是工具类

3. mybatis概述

   使用了ORM思想实现了结果集的封装

   ORM（Object Relational Mapping  对象关系映射）：

   - 把数据库表及实体类的属性对应起来，让我们可以操作实体类就实现操作数据库表

4. mybatis的入门

   1. 环境搭建
      1. 创建maven工程并导入坐标
      2. 创建实体类和dao接口
      3. 创建mybatis的主配置文件
      4. 创建映射配置文件
      
   2. 环境搭建的注意事项

      1. 在mybatis中持久层的操作接口名称和映射文件也叫做：Mapper
      2. mybatis的映射文件位置必须与dao接口的包结构相同
      3. 映射配置文件的mapper标记namespace属性的取值必须是dao接口的全限定类名
      4. 映射配置文件的操作配置（select等等），id属性的取值必须是dao接口的方法名
      5. （遵循2，3，4点后，开发中就无需再写dao实现类）

      

   3. 简单案例

      1. 主配置文件

      ```xml
      <?xml version="1.0" encoding="UTF-8" ?>
      <!DOCTYPE configuration
              PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
              "http://mybatis.org/dtd/mybatis-3-config.dtd">
      
      <!--mybatis的主配置文件-->
      <configuration>
      
          <properties resource="jdbc.properties" />
      
          <!--配置环境-->
          <environments default="mysql">
              <!--配置mysql环境-->
              <environment id="mysql">
                  <!--配置事务类型-->
                  <!--<transactionManager type="JDBC"  /> 这里type="JDBC"表示按照原始jdbc模式进行，所以回滚或提交需要手写 -->
                  <transactionManager type="JDBC"  />
                  <!--配置数据源（连接池）-->
                  <dataSource type="POOLED">
                      <!--配置数据库的4个信息-->
                      <property name="driver" value="${driver}"/>
                      <property name="url" value="${url}"/>
                      <property name="username" value="${username}"/>
                      <property name="password" value="${password}"/>
      
                  </dataSource>
              </environment>
          </environments>
      
          <!--指定映射配置文件的位置，映射配置文件是指每一个dao独立的配置文件-->
          <mappers>
              <mapper resource="com/by/dao/UserMapper.xml" />
          </mappers>
      </configuration>
      ```
   
2. 映射文件
   
```xml
      <?xml version="1.0" encoding="UTF-8" ?>
      <!DOCTYPE mapper
              PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
              "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
      
      <mapper namespace="com.by.dao.UserMapper">
      
          <!--配置查询所有-->
          <select id="findAll" resultType="com.by.domain.User">
              select * from t_user
          </select>
      </mapper>
```

3. 资源文件
   
```properties
      driver=com.mysql.cj.jdbc.Driver
      url=jdbc:mysql://localhost:3306/数据库名?serverTimezone=UTC
      username=用户名
      password=密码
```

4. 实体类
   
```java
      public class User implements Serializable {
          private Integer id;
          private String username;
          private Date birthday;
          private String sex;
          private String address;
      
          public User() {
          }
      
          public User(Integer id, String username, Date birthday, String sex, String address) {
              this.id = id;
              this.username = username;
              this.birthday = birthday;
              this.sex = sex;
              this.address = address;
          }
      
          public Integer getId() {
              return id;      
          }
      
          public void setId(Integer id) {
              this.id = id;
          }
      
          public String getUsername() {
              return username;
          }
      
          public void setUsername(String username) {
              this.username = username;
          }
      
          public Date getBirthday() {
              return birthday;
          }
      
          public void setBirthday(Date birthday) {
              this.birthday = birthday;
          }
      
          public String getSex() {
              return sex;
          }
      
          public void setSex(String sex) {
              this.sex = sex;
          }
      
          public String getAddress() {
              return address;
          }
      
          public void setAddress(String address) {
              this.address = address;
          }
      
          @Override
          public String toString() {
              return "User{" +
                      "id=" + id +
                      ", username='" + username + '\'' +
                      ", birthday=" + birthday +
                      ", sex='" + sex + '\'' +
                      ", address='" + address + '\'' +
                      '}';
          }
      }
```

5. 持久层接口
   
```java
      public interface UserMapper {
          public List<User> findAll();
      }
```

6. 测试类
   
```java
      public class MyBatisTest {
          /**
           * MyBatis入门案例
           * @param args
           */
          public static void main(String[] args) throws IOException {
              //1.读取配置文件
              InputStream is = Resources.getResourceAsStream("mybatis-config.xml");
              //2.创建SqlSessionFactory工厂
              SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
              SqlSessionFactory factory = builder.build(is);
              //3.使用工厂生产SqlSession对象
              //SqlSession session = factory.openSession(true);//设置为true表示自动提交，默认为false
              SqlSession session = factory.openSession();
              //4.使用SqlSession创建Dao接口的代理对象
              UserMapper userDao = session.getMapper(UserMapper.class);
              //5.使用代理对象执行方法
              List<User> userList = userDao.findAll();
      
              for (User user : userList) {
                  System.out.println(user);
              }
              //6.释放资源
              session.close();
              in.close();
          }
      }
```





## 二、基础

1. 通过package管理映射文件的引入

```xml
<!--修改在主配置文件里的信息-->
<mappers>
        <!--此种写法可以直接引入包下的所有映射文件，但是必须要求mapper接口与映射文件在同一个包下-->
        <package name="com.by.dao"/>
</mappers>
```

2. 对于有参数的方法，可以设置parameterType（不写也可以，mybatis会自动识别，但是为了规范，代码可读性，还是写上好）

```xml
<update id="方法名" parameterType="参数类型">
    update xxx set xxx =xxx where xx=xx;
</update>
```

3. **mybatis获取值的两种方式**

```
${}
使用Statement，使用字符串拼接的方法，有SQL注入风险
一般在模糊查询与批量删除时使用

#{}
使用PrepareStatement，可以防止SQL注入
```

4. 获取自动生成的主键

```java
1. 在原生的jdbc中有conn.prepareStatement(sql语句，1)方法//第二个参数设置为1就可以获得自动返回的信息
调用
Resultset rs = ps.getGeneratedKeys();
rs.next();
int id = rs.getInt(1);//获取自动生成的主键

```

```xml
2. mybatis中的设置(useGeneratedKeys默认就是true)
<insert id="方法名" useGeneratedKeys="true" keyProperty="对象的属性名" >
    insert into xxx values(xxx,xxx,#{xxx})
</insert>
```

5. 获取不同参数值的方式

```java
1. 传入单个String或基本数据类型及其包装类的参数
${value}或者${_parameter}
//必须为value或_parameter，不管入参叫什么

#{xxx}
//参数名任意，但尽量与入参保持一致



2. 传入一个Javabean
#{}与${}都能通过属性名直接获取属性值，但是要注意${}的字符类型的单引号问题



3. 当传输多个参数时，mybatis会默认将参数放入map集合中
两种方式：
	（1）以0，1，2，... ，N-1为键，以参数为值
	（2）以param1，param2，... ，paramN为键，以参数为值
#{0}或#{param1}表示第一个参数
#{1}或#{param2}表示第二个参数，以此类推

${param1}表示第一个参数
${param2}表示第二个参数，以此类推



4. 当传输map参数时
#{}与${}都能通过键的名字直接获取值，但是要注意${}的字符类型的单引号问题



5. 对3的另一种写法，就是在接口中加上@Param("key")注解来指定map集合中的键
Object getUserByIdAndNameByParam(@Param("id")String id,@Param("name")String name);



6. 当参数为List或Array，mybatis会默认放入map集合中
List以list为键
Array以array为键

```

6. 多对一自定义映射

```xml
<!--写法一-->
<!--
    当处理复杂的表关系的查询结果不能满足属性名直接映射时，需要进行自定义映射配置，
    假设User对象中还有一个Dept对象
-->
<!--自定义映射配置-->
<resultMap id="User" type="userDept">
    
    <!--id专门设置主键的映射，column是列名，property是属性名 -->
    <id column="id" property="id" />
    <!-- result设置非主键的映射 -->
    <result column="name" property="name" />
    <result column="did" property="dept.did" />
    <result column="dname" property="dept.dname" />

</resultMap>

<select id="findAllUser" resultMap="userDept">
    select u.id, u.name, u.did, d.dname from t_user u left join t_dapt d on u.did=d.did
</select>


<!--或者---------------------------------------------->
<!--写法二-->
<!--自定义映射配置-->
<resultMap id="User" type="userDept">
    <id column="id" property="id" />
    <result column="name" property="name" />
    
    <!--property为属性名，javaType为对象类型（全限定类名）-->
    <association property="dept" javaType="Dept">
        <id column="did" property="did" />
        <result column="dname" property="dname" />
    </association>
    
</resultMap>
<select id="findAllUser" resultMap="userDept">
    select u.id, u.name, u.did, d.dname from t_user u left join t_dapt d on u.did=d.did
</select>
```





*（后续再补充）*



## 注释注入SQL

e.g.

```java
@Repository
public interface UserMapper {

    @Select("select * from t_user where user_id = #{id}")
    public User select(Integer id);

    @Insert("insert into t_user (user_name) values (#{userName})")
    @Options(useGeneratedKeys = true,keyProperty = "userId")
    public boolean insert(User user);
}
```

```yaml
mybatis:
  configuration:
    map-underscore-to-camel-case: true #开启下划线自动转驼峰格式
```

