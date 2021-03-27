# Spring 5

> 仅个人笔记

## 一、Spring框架概述

1. Spring是轻量级的开源的JavaEE框架，是针对bean的生命周期进行管理的容器

2. 可以解决企业开发的复杂性

3. 有两个核心部分：IOC和AOP
   1. IOC：控制反转，把创建对象过程交给Spring进行管理
   2. AOP：面向切面，不修改源代码进行功能增强
4. 特点
   - 方便解耦，简化开发
   - AOP编程的支持
   - 声明式事务的支持
   - 方便程序的测试
   - 方便集成各种优秀框架
   - 降低Java EE API 的使用难度
   - 其源码是经典学习范例



## 二、入门案例

1. 引入spring5的jar包（我用的是5.2.8）

   稳定版下载位置：https://repo.spring.io/release/org/springframework/spring/

2. 导入以下5个jar包

![image-20200808152825802](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20200808152825802.png)

3. 添加到依赖中

4. 创建普通类，创建普通方法

5. 创建spring配置文件，在配置文件中配置创建的对象

   1. spring配置文件使用xml格式

   ```java
   //普通类
   public class User {
       public  void  add(){
           System.out.println("add.......");
       }
   }
   ```

   ```xml
   <?xml version="1.0" encoding="UTF-8" ?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
          xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">
   
   <!--配置文件-->
       <bean id="user" class="com.by.User">
       </bean>
   
   </beans>
   ```

   ```java
   //测试类
   public class TestSpring5 {
       
       @Test
       public void addTest(){
           //加载配置文件
           ApplicationContext context =
                   new ClassPathXmlApplicationContext("spring-config.xml");
   
           //获取配置文件创建的对象
           User user = context.getBean("user", User.class);
   
           System.out.println(user);
           user.add();
       }
   }
   ```



## 三、IOC容器

### IOC过程

1. xml配置文件，配置创建的对象

   ```xml
   <bean id="xxx" class="全类名" ></bean>
   ```

2. 有service层与dao层，创建工厂类

3. 反射



### IOC（接口）

1. IOC思想基于IOC容器完成，IOC容器底层就是对象工厂

2. Spring提供IOC容器实现的两种方式：

   1. BeanFactory：IOC容器基本实现，是Spring内部的使用接口，不提供开发人员进行使用
      - （懒加载）
   2. ApplicationContext：BeanFactory接口的子接口，提供了更多的功能，一般由开发人员进行使用

3. ApplicationContext的主要实现类

   ![image-20200808165532430](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20200808165532430.png)

   1. FileSystemXmlApplicationContext

      配置文件在盘里的路径

   2. ClassPathXmlApplicationContext

      配置文件的类路径



### IOC操作Bean管理

> Bean管理，就是spring进行创建对象与属性注入

#### Bean管理操作有两种方式：

1. 基于xml配置文件方式实现

   ```xml
   <!--1.创建对象-->
   在xml文件里使用bean标签
   <bean></bean>
   
   <!--bean标签的常用属性-->
   id:标识名
   class:全限定类名
   name:标识名，相比id，name可以使用特殊符号（不常用了）
   
   创建对象的时候，默认执行无参构造方法
   
   <!----------------------------------------------------------------->
   
   <!--2.注入属性-->
   
   DI:依赖注入，也就是注入属性
   方法1：
       1. 设置set方法
       2. 在xml文件中的bean中使用property标签
   
   
   
   方法2：
   	1. 构造有参构造器
   	2. 在xml文件中的bean中使用constructor-arg标签
   
   
   
   注入空值或特殊符号或其他值：
   
   	1.字面量：
   		1. null
   		<property name="age" >
               <null />
           </property>
   
   		2. 属性值包含特殊符号
   			可以使用转义字符比如&lt;&gt;等等
   			也可以使用CDATA表达，比如输出<<哦豁>>
   			<value> <![CDATA[<<哦豁>>]]> </value>
   
   	2. 外部bean
   	<!--ref: 填需要的bean对象的bean标签的id值 -->
       <property name="userDao" ref="" ></property>
   
   
   	3. 内部bean和级联赋值
   		内部bean: 直接在property内嵌套bean标签
   		级联赋值: 
   			1. 生成get方法
   			2. 使用对象.属性的方式级联赋值
   
   
   <!----------------------------------------------------------------->
   
   <!--3.对于工厂Bean的管理-->
   可以通过普通类实现FactoryBean接口来管理
   
   
   <!----------------------------------------------------------------->
   
   <!--4.bean的作用域与生命周期-->
   作用域：Spring里面，可以设置bean实例是单实例还是多实例（默认是单实例）
   	怎么设置: bean标签的scope属性
   		scope=singleton，表示单实例对象
   		scope=prototype，表示多实例对象
   
   生命周期: 创建到销毁的过程
   	1. 通过构造器创建实例
   	2. 调用set方法
   	3. 把bean传递给bean后置处理器（后置处理器:实现BeanPostProcessor接口的类）
   	4. 调用初始化方法（需要配置）
   	5. 把bean传递给bean后置处理器
   	6. 获得bean对象
   	7. 容器关闭时，调用bean的销毁方法（需要配置）
   
   
   <!----------------------------------------------------------------->
   
   <!--5.xml自动装配-->
   bean标签内的autowire属性
   	autowire="byName" 根据属性名注入（注入值id值要和类属性名称一样）
   	autowire="byType" 根据属性类型注入
   
   
   
   <!----------------------------------------------------------------->
   
   <!--6.引入外部文件-->
   1. 引入context名称空间
   <!--在头部约束加入下面两句-->
   	xmlns:context="http://www.springframework.org/schema/context"
   	http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd
   如下：
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
          xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                              http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.0.xsd">
       
       
   2.引入外部文件，配置连接池对象（这里使用了德鲁伊连接池）
       <!--引入外部文件-->
       <context:property-placeholder location="jdbc.properties" />
       <!--配置连接池对象-->
       <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
           <property name="driverClassName" value="${driver}" />
           <property name="url" value="${url}" />
           <property name="username" value="${username}" />
           <property name="password" value="${password}" />
       </bean>
       
       
   ```

2. 基于注解方式实现

   ```java
   //创建对象
   @Component 普通组件注解
   @Service 
   @Controller
   @Repository
   //上面4个注解的功能是一样的，都可以用来创建bean实例，不过还是按意义来比较好
   
   /**步骤：    
    *  1.引入依赖
    *  2.开启组件扫描（在xml文件内配置指定扫描的文件的位置，多个包之间可以用逗号隔开）
    *  3.创建类，在类上面添加创建对象注解
    */
      
   <!--开启组件扫描-->
   <context:component-scan base-package="com.by.demo1" />  
       
   //相当于<bean id="userService" class=全类名 ></bean>
   @Service(value = "userService" /*value如果不写，默认是类名，首字母小写*/ )  
   public class UserService {
       public void add(){
           System.out.println("UserService.add.........");
       }
   }
   
   
   //------------------------------------------------------------------------------
   
   //注入属性
   
   @Autowired 根据属性类型自动装配
   @Qualifier 根据属性名称进行注入（一般与Autowired一起使用）
   @Resource 可以根据属性类型，也可以根据属性名称注入
   @Value 注入普通属性
       
   /**步骤：    
    *  1.创建service和dao对象
    *  2.在service注入dao对象，在service类添加dao类型属性，在属性上面使用注解
    */
   
   public interface UserDao {
       void add();
   }
   
   @Repository
   public class UserDaoImpl implements UserDao {
       public void add() {
           System.out.println("UserDaoImpl.add..........");
       }
   }
   
   @Service
   public class UserService {
       @Autowired
       @Qualifier(value = "userDaoImpl")
       private UserDao userDao;
   
       public void add(){
           System.out.println("UserService.add.........");
           userDao.add();
       }
   }
   
   //------------------------------------------------------------------------------
   
   //完全注解开发
   
   /**
    *1.创建配置类，替代xml配置文件
    *2.测试使用加载配置文件的类需要改变为AnnotationConfigApplicationContext
    */
   
   //配置类
   @Configuration
   @ComponentScan(basePackages = "com.by.demo1")
   public class SpringConfig {
   }
   
   //使用配置类进行测试
   @Test
   public void userServiceTest2(){
       //加载配置文件
       ApplicationContext context =
           new AnnotationConfigApplicationContext(SpringConfig.class);
       //获取配置文件创建的对象
       UserService userService = context.getBean("userService", UserService.class);
       System.out.println(userService);
   	userService.add();
   }    
   ```





## 四、AOP

> 面向切面，不修改源代码进行功能增强。AOP是OOP的延续，是软件开发中的一个热点，也是Spring框架中的一个重要内容，是函数式编程的一种衍生范型。利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率。

### AOP常见术语

1. 连接点（JoinPoint）：类里面可以被增强的方法称为连接点
2. 切入点（Pointcut）：实际真正被增强的方法称为切入点
3. 通知（增强）（Advice）：实际增强（添加）的逻辑部分称为通知（增强）
   1. 前置通知 @Before
   2. 后置通知（返回通知） @AfterReturning
   3. 环绕通知 @Around
   4. 异常通知 @AfterThrowing
   5. 最终通知 @After
4. 切面（Aspect）：把通知应用到切入点的过程称为切面



### AOP操作（准备）

1. spring框架一般基于AspectJ实现AOP操作

   - AspectJ不是Spring组成部分，是一个独立的AOP框架，一般把AspectJ和Spring框架一起使用，进行AOP操作

2. 基于AspectJ实现AOP操作

   1. 基于xml文件
   2. 基于注解方法（使用较多）

3. 导jar包

4. 切入点表达式

   1. 作用：知道对哪个类的哪个方法进行增强

   2. 语法结构：

      ```java
      execution([权限修饰符][返回类型][类全路径][方法名]([参数列表]))
      
      栗子1：对com.by.dao.UserDao类的add方法进行增强
      //*表示任意（注意空格），参数列表的..表示方法中的参数
      execution(* com.by.dao.UserDao.add(..))
      
      栗子2：对com.by.dao.UserDao类的所有方法进行增强
      execution(* com.by.dao.UserDao.*(..))
      
      栗子3：对com.by.dao内所有类的所有方法进行增强
      execution(* com.by.dao.*.*(..))
      
      ```





### AOP操作

#### AspectJ基于注解

1. 创建类，创建方法

2. 创建增强类

3. 添加创建对象注解

4. 配置xml文件开启扫描

5. 添加代理类注解

6. 配置xml文件开启AspectJ创建代理对象

7. 测试

   1. 配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:context="http://www.springframework.org/schema/context"
          xmlns:aop="http://www.springframework.org/schema/aop"
          xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                              http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
                              http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop.xsd">
   
       <!--开启扫描-->
       <context:component-scan base-package="com.by.aop.anno"  />
       <!--开启aspect生成代理对象-->
       <aop:aspectj-autoproxy />
       
   </beans>
   ```

   2. 被增强类与增强类与测试类

   ```java
   @Component
   public class User {
       //该类为被代理类
   
       public void add(){
           System.out.println("add...............");
       }
   }
   
   //-----------------------------------------------------
   
   @Component
   @Aspect  //表示该类为代理类
   public class UserProxy {
   
       @Before(value = "execution(* com.by.aop.anno.User.add(..))")
       public void before(){
           System.out.println("before...................");
       }
   
       @After(value = "execution(* com.by.aop.anno.User.add(..))")
       public void after(){
           System.out.println("after...................");
       }
   
       @AfterReturning(value = "execution(* com.by.aop.anno.User.add(..))")
       public void afterReturning(){
           System.out.println("afterReturning...................");
       }
   
       @AfterThrowing(value = "execution(* com.by.aop.anno.User.add(..))")
       public void afterThrowing(){
           System.out.println("afterThrowing...................");
       }
   
   
       @Around(value = "execution(* com.by.aop.anno.User.add(..))")
       public void around(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
           System.out.println("环绕前");
   
           //被增强的方法
           proceedingJoinPoint.proceed();
   
           System.out.println("环绕后");
       }
   }
   
   //---------------------------------------------------------------------------------
   
   //测试类
   public class TestAOP {
       @Test
       public void testAOPByAnno(){
           ApplicationContext context =
                   new ClassPathXmlApplicationContext("spring-config.xml");
   
           User user = context.getBean("user", User.class);
           user.add();
       }
   }
   ```

8. 抽取相同切入点（非必须）

   ```java
   @Pointcut(value = "execution(* com.by.aop.anno.User.add(..))")
   public void point(){}
   
   @Before(value = "point()")
   public void before(){
       System.out.println("before...................");
   }
   
   @After(value = "point()")
   public void after(){
       System.out.println("after...................");
   }
   ```

9. 有多个增强类对同一个方法增强，可设置增强类优先级

   - 在增强类上面添加注解@Order(数字类型值)，数字越小优先级越高





#### AspectJ基于xml

配置文件

```xml
<!--创建对象-->
<bean id="user" class="com.by.aop.User" />
<bean id="userProxy" class="com.by.aop.UserProxy" />

<!--配置增强-->
<aop:config>
	<!--配置切入点-->
    <aop:pointcut id="userAdd" expression="execution(* com.by.aop.User.add(..))"/>

	<!--配置切面-->   
    <aop:aspect ref="userProxy">
        <aop:before method="before" pointcut-ref="userAdd" />
    </aop:aspect>
</aop:config>
```



## 五、事务操作

### 事务

事务是数据库操作的最基本单元

### 四大特性

1. 原子性
2. 一致性
3. 隔离性
4. 持久性

### 搭建事务操作环境

1. 创建数据库表，添加记录
2. 创建service与dao，完成对象创建和注入关系

### 具体操作

有两种方法：编程式与声明式



#### spring事务管理API

1. 提供了一个接口，代表事务管理器，这个接口针对不同的框架提供不同的实现类



#### 编程式事务管理（少用）

逻辑内嵌到代码中，就是编程式事务管理



#### 声明式事务管理（底层使用AOP原理）

1. 基于注解（最常用）

   1. 在spring配置文件中配置事务管理器

      ```xml
      <!--创建事务管理器-->
      <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager" >
      
          <!--注入数据源-->
          <property name="dataSource" ref="dataSource"></property>
      
      </bean>
      ```

   2. 开启事务注解

      1. 引入名称空间tx

         ```xml
         xmlns:tx="http://www.springframework.org/schema/tx"
         "http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx.xsd"
         ```

      2. 开启事务注解

         ```xml
         <!--开启事务注解-->
         <tx:annotation-driven transaction-manager="transactionManager" ></tx:annotation-driven>
         ```

   3. 在service类上面（或者service类里面方法上面）添加事务注解

      ```java
      @Transactional
      ```

      Transactional的一些参数配置

      1. propagation：事务传播行为

         - 多事务方法直接调用，这个过程中事务是如何进行管理的（有7种）（常用的就REQUIRED与REQUIRE_NEW）
         - REQUIRE_NEW 表示必须在自己的事务中运行，否则就会挂起

      2. ioslation：事务隔离级别

         | ioslation值                                  | 脏读 | 不可重复读 | 幻读 |
         | -------------------------------------------- | ---- | ---------- | ---- |
         | READ UNCOMMITTED（读未提交）                 | 有   | 有         | 有   |
         | READ COMMITTED（读已提交）                   | 无   | 有         | 有   |
         | REPEATABLE READ（可重复读）（MySQL的默认值） | 无   | 无         | 有   |
         | SERIALIZABLE（串行化）                       | 无   | 无         | 无   |

      3. timeout：超时时间

         - 默认为-1，单位是秒

      4. readOnly：是否只读

         - 默认false

      5. rollbackFor：回滚

         - 设置出现哪些异常进行事务回滚

      6. noRollbackFor：不回滚

         - 设置出现哪些异常不进行事务回滚

2. 基于xml





