# springSecurity

springboot底层安全模块默认的技术选型，可以实现强大的web安全控制。对于安全控制，仅需要引入spring-boot-starter-security模块，进行少量的配置，即可实现强大的安全管理。

- WebSecurityConfigurerAdapter：自定义security策略
- AuthenticationManagerBuilder：自定义认证策略
- @EnableWebSecurity：开启WebSecurity模式

spring Security的两个主要目标是“认证”和“授权”（访问控制）。“认证”（Authentication），“授权”（Authorization）。



1. 导包

   ```xml
   <!--security-->
   <!-- https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-security -->
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-security</artifactId>
       <version>2.3.3.RELEASE</version>
   </dependency>
   ```

2. 使用配置类

   ```java
   @EnableWebSecurity//这个要开
   public class SecurityConfig extends WebSecurityConfigurerAdapter {
   
       /**
        * 定制授权
        * @param http
        * @throws Exception
        */
       @Override
       protected void configure(HttpSecurity http) throws Exception {
           http.authorizeRequests()
                   .antMatchers("/").permitAll()
                   .antMatchers("/level1/**").hasRole("vip1")
                   .antMatchers("/level2/**").hasRole("vip2")
                   .antMatchers("/level3/**").hasRole("vip3")
           ;
   
           //没有权限默认会跳掉登录页面
           http.formLogin()
                   .loginPage("/toLoginTest")//定制登录页，登录页的路径
                   .usernameParameter("userName")//用户名参数名自定义
                   .passwordParameter("pwd")//密码参数名自定义
                   .loginProcessingUrl("/pLogin")//登录处理url，即登录表单提交至的url
           ;
   
           //开启注销
           http.logout();
   
           http.csrf().disable();
   
           //记住我功能 cookie
           http.rememberMe()
                   .rememberMeParameter("remember")//自定义记住我参数名称
           ;
   
   
       }
   
       /**
        * 定制认证
        * 需要密码编码加密：PasswordEncoder
        * @param auth
        * @throws Exception
        */
       @Override
       protected void configure(AuthenticationManagerBuilder auth) throws Exception {
           auth
                   .inMemoryAuthentication()/*配置在内存中的用户认证*/
                   .passwordEncoder(new BCryptPasswordEncoder())//添加加密类
                   //这些数据正常应该从数据库中读
                   .withUser("root1").password(new BCryptPasswordEncoder().encode("123456")/*进行编码*/).roles("vip1")
                   .and()//拼接
                   .withUser("root2").password(new BCryptPasswordEncoder().encode("123456"))
               	.roles("vip1","vip2")
                   .and()
                   .withUser("root3").password(new BCryptPasswordEncoder().encode("123456"))
               	.roles("vip1","vip2","vip3")
                   ;
   
       }
   }
   ```

   



