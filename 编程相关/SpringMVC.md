# SpringMVC

## 搭建过程

1. 导jar

2. 在web.xml中配置springMVC的核心（前端）控制器DispatcherServlet

   ```xml
   <servlet>
       <servlet-name>springMVC</servlet-name>
       <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
   </servlet>
   <servlet-mapping>
       <servlet-name>springMVC</servlet-name>
       <url-pattern>/</url-pattern>
   </servlet-mapping>
   ```

   1. 作用：加载springMVC的配置文件
   2. 配置文件默认在WEB-INF下，且名称为<servlet-name>-servlet.xml

3. 创建一个POJO，在类上加@Controller注解，springMVC就会将此类作为控制层加载，让其处理请求响应

4. xml控制开启扫描

   ```xml
   <!--扫描组件，将加@Controller注解的类作为springMVC的控制层-->
   <context:component-scan base-package="com.by.controller"  />
   
   <!--配置视图解析器-->
   <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
       <property name="prefix" value="/WEB-INF/view/" />
       <property name="suffix" value=".jsp" />
   </bean>
   ```

5. 在控制层中，需要在方法上设置@RequestMapping(value = "xxx")

6. 处理请求的方法会返回一个字符串，即视图名称，最终会通过配置文件中的视图解析器实现页面跳转

   方式：prefix + 视图名称 + suffix ，此为最终页面跳转的路径

## 例子

1. web.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
            version="4.0">
       
       
       <servlet>
           <servlet-name>springMVC</servlet-name>
           <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
           
           <init-param>
               <param-name>contextConfigLocation</param-name>
               <!--配置文件直接丢资源包里了-->
               <param-value>classpath:springMVC-servlet.xml</param-value>
           </init-param>
       </servlet>
       <servlet-mapping>
           <servlet-name>springMVC</servlet-name>
           <url-pattern>/</url-pattern>
       </servlet-mapping>
       
   </web-app>
   ```

2. springMVC-servlet.xml

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
          xmlns:context="http://www.springframework.org/schema/context"
          xmlns:mvc="http://www.springframework.org/schema/mvc"
          xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                              http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
                              http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd">
   
       <!--扫描组件，将加@Controller注解的类作为springMVC的控制层-->
       <context:component-scan base-package="com.by.controller"  />
       <mvc:default-servlet-handler />
       <mvc:annotation-driven/>
   
       <!--配置视图解析器-->
       <bean id="viewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
           <property name="prefix" value="/WEB-INF/view/" />
           <property name="suffix" value=".jsp" />
       </bean>
   </beans>
   ```

3. 测试类

   ```java
   @Controller
   public class TestController {
       /**
        * 假设访问：localhost:8080/springMVC/hello
        */
       @RequestMapping(value = "hello")
       public String hello(Model model) {
           System.out.println("success");
           //返回的字符串会被视图解析器解析
           return "hello";
       }
   }
   ```

4. 把相应的包下的视图建好

5. 问题：idea发布的项目可能会没有添加环境



## 其他内容

1. 方法return的字符串如果加上前缀forward:或redirect:（冒号不要忘了）
   1. forward:
      - 请求转发

   2. redirect:
      - 重定向

2. 乱码问题

   - 配置一个字符集过滤器就行

   ```xml
   <filter>
       <filter-name>encoding</filter-name>
       <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
   </filter>
   <filter-mapping>
       <filter-name>encoding</filter-name>
       <url-pattern>/*</url-pattern>
   </filter-mapping>
   ```

   

