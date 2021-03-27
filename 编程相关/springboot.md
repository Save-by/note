# springboot

## 基础配置入门

### resources文件夹

1. application.properties文件

   - ```properties
     #（更改项目的端口为8081，默认为8080）
     server.port = 8081 
     ```

2. 新建banner.txt文件

   放入喜欢的字符组合图（算彩蛋）





### src文件夹





## 分散的知识点

1. 默认扫描器 basepackage （就是主启动类所在的包）

2. 热部署

   1. 需要插件

   ```xml
   <dependency>
               <groupId>org.springframework.boot</groupId>
               <artifactId>spring-boot-loader-tools</artifactId>
               <optional>true</optional>
   </dependency>
   ```

   2. 需要触发

      - ctrl + shift + alt + /

        在Registry里勾选compiler.automake.allow.when.app.running

        <img src="C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201020174940853.png" alt="image-20201020174940853" style="zoom: 200%;" />

      - 勾选自动编译

        ![image-20201020175148416](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20201020175148416.png)

   3. 最后上线要进行禁用设置

      ```properties
      -Dspring.devtools.restart.enabled=false
      ```

   4. 排除某些文件夹下的文件的热部署
   
      ```properties
      spring.devtools.restart.exclude=static/**,public/**
      ```

### 主配置文件的位置

1. 主配置文件命名为application.properties或者application.yml
2. springboot启动会扫描以下位置的application.properties或者application.yml文件作为springboot的默认配置文件
   1. -file:./config/
   2. -file:./
   3. -classpath:/config/
   4. -classpath:/
   5. 优先级由高到低，高优先级的配置会覆盖低优先级的配置，四个位置的配置都会进行加载，互补配置 



### yaml

yml是YAML语言的文件，以数据为中心，比properties、xml等更适合做配置文件

1. yml与xml相比，少了一些结构化的代码，使数据更直接
2. 相比properties文件更简洁

#### 例子

```yaml
environments:
	dev:
		url: http://xxxx.com
		name: xxxx
	prod:
		url: http://ttt.com
		name: ttt
```

1. 同一级要对齐，可以是空格（多少都可以），也可以是缩进
2. 在具体内容与层级的冒号之间要有空格隔开
3. 大小写敏感
4. 支持字面值，对象，数组三种数据结构，也支持复合结构
   1. 字面值： 字符串，布尔类型，数值，日期。字符串默认不加引号，单引号会转义特殊字符。日期格式支持yyyy/MM/dd HH:mm:ss
   2. 对象： 由键值对组成，形如key:(空格)value 的数据组成。冒号后面的空格是必须要有的，每组键值对占用一行，且缩进的程度要一致，也可以使用行内写法：{k1: v1,....kn: vn}
   3. 数组： 由形如 -(空格)value 的数据组成。短横线后面的空格是必须要有的，每组数据占用一行且缩进的程度要一致，也可以使用行内写法：[1,2,....n]
   4. 复合结构： 上面三种数据结构任意组合

***（yml文件是松散绑定的）***

```yaml
same:
	myCode: xxx
	my-code: xxx
	my_code: xxx
	MY_CODE: xxx  #这种一般在系统环境中建议使用
#上面几种都是支持并可以进行注入的
```



### yml文件的读取

#### 例子1（通过set get实现）

1. 实体类

   ```java
   @Data
   @NoArgsConstructor
   @AllArgsConstructor
   @Component
   @ConfigurationProperties(prefix = "yaml.level")
   public class YamlModel {
   
       private String str;
       private String specialStr;
       private int num;
       private double dNum;
       private Date birth;
   
       private List<String> listOne;
       private List<String> listTwo;
   
   
       private Set<Integer> set;
   
       private Map<String,String> mapOne;
       private Map<String,String> mapTwo;
   
       private List<User> users;
   
   }
   
   
   //------------------------------------------------------
   
   @Data
   @NoArgsConstructor
   @AllArgsConstructor
   public class User {
       private String name;
       private double high;
   }
   ```

2. yml文件

   ```yaml
   #这个是注释的写法
   
   yaml:
     level:
       str: 字符串一号
       specialStr: "添加双引号可以使特殊字符不被转义，等下会出现\n换了一行"
       num: 996
       Dnum: 985.211
    birth: 2020/10/23 22:20:59
       listOne:
         - one
         - two
         - three
       listTwo: [four,five,six]
       set:
         - 1
         - 2
         - 3
         - 1
       mapOne: {k1: v1,k2: v2,k3: v3}
       mapTwo:
         k4: v4
         k5: v5
         k6: v6
   
       users:
         - name: tom
           high: 180.1
         - name: jack
           high: 210.5
   ```
   
3. 为了方便在配置文件中显示对应的实体类的属性的提示，可以添加依赖

   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-configuration-processor</artifactId>
       <optional>true</optional>
   </dependency>
   ```

#### 例子2（通过构造器实现）

1. 实体类

   ```java
   @Data
   @AllArgsConstructor
   @NoArgsConstructor
   @ConfigurationProperties(prefix = "yaml.cons")
   @ConstructorBinding //通过构造器注入
   public class YamlConstructorTest {
   
       private String str;
       private int num;
   }
   ```

2. controller控制层接口

   ```java
   @RestController
   @EnableConfigurationProperties(YamlConstructorTest.class)//开启配置文件参数的注入
   public class YamlController {
   
       @Autowired
       private YamlConstructorTest cons; //这里idea会报一个红，不过好像不影响
   
       @RequestMapping("/cons")
       public YamlConstructorTest test(){
           
           System.out.println(cons);
           return cons;
       }
   }
   ```

3. yaml文件

   ```yaml
   yaml:
     cons:
       str: xxx
       num: 222
   ```




### 属性绑定的校验





//整合jdbc使用



## 整合Mybatis

1. 引入依赖（使用maven）

   ```xml
   <!-->mybatis-spring-boot-starter-->
   <dependency>
       <groupId>org.mybatis.spring.boot</groupId>
       <artifactId>mybatis-spring-boot-starter</artifactId>
       <version>2.1.1</version>
   </dependency>
   
   <!--mysql驱动-->
   <dependency>
       <groupId>mysql</groupId>
       <artifactId>mysql-connector-java</artifactId>
       <scope>runtime</scope>
   </dependency>
   ```

2. 主配置文件application.yml

   ```yaml
   #配置数据库连接信息
   spring:
     datasource:
       username: root  #这里使用自己的用户名与密码
       password: 123456 #这里使用自己的用户名与密码
       url: jdbc:mysql://localhost:3306/数据库名称?serverTimezone=UTC
       driver-class-name: com.mysql.cj.jdbc.Driver
   
   
   mybatis:
     configuration:
       map-underscore-to-camel-case: true #开启字段下划线自动转驼峰格式 如user_id 对应 userId
   ```

3. 实体类

   ```java
   //这里用了Lombok简化实体类的内容
   @Data
   @NoArgsConstructor
   @AllArgsConstructor
   public class User {
       private Integer userId;
       private String userName;
   
   }
   ```

4. 持久层Mapper（Dao）

   ```java
   @Mapper
   @Repository
   public interface UserMapper {
   
       @Select("select * from t_user where user_id = #{id}")
       public User select(Integer id);
   
       @Insert("insert into t_user (user_name) values (#{userName})")
       @Options(useGeneratedKeys = true,keyProperty = "userId") //获取自增的主键值,并注入入参user的userId中
       public boolean insert(User user);
   }
   ```

5. Controller层测试（为了方便省略service层）

   ```java
   @RestController
   public class TestController {
   
       @Autowired
       UserMapper userMapper;
   
       @GetMapping("/select/{id}")
       public User select(@PathVariable("id") int id){
           User select = userMapper.select(id);
           System.out.println(select);
           return select ;
       }
   
       @GetMapping("/insert/{userName}")
       public User insert(@PathVariable("userName") String userName){
           User user = new User(null, userName);
           boolean insert = userMapper.insert(user);
           System.out.println(insert);
           System.out.println(user);
   
           return user ;
       }
   }
   ```







## Swagger

1. 导依赖

   ```xml
   <dependency>
               <groupId>io.springfox</groupId>
               <artifactId>springfox-boot-starter</artifactId>
               <version>3.0.0</version>
   </dependency>
   ```

2. 注意

   - 应用主类增加注解`@EnableOpenApi`（删除之前版本的SwaggerConfig.java    ？）

   - 启动项目，访问地址：`http://localhost:8080/swagger-ui/index.html`

   - 附：2.x版本中访问的地址的为`http://localhost:8080/swagger-ui.html`

3. 代码示例

   ```java
   @Data
   @AllArgsConstructor
   @NoArgsConstructor
   @ApiModel("用户实体")  //实体描述，我们可以通过 @ApiModel 和 @ApiModelProperty 注解来对我们 API 中所涉及到的对象做描述
   public class User {
   
       @ApiModelProperty("用户id")
       private Integer id;
   
       @ApiModelProperty("用户名")
       private String userName;
   }
   ```

   ```java
   @RestController
   @Api(tags = "用户相关接口", description = "提供用户相关的 Rest API")//通过在控制器类上增加 @Api 注解，可以给控制器增加描述和标签信息
   public class UserController {
   
       @ApiOperation("新增用户接口")//通过在接口方法上增加 @ApiOperation 注解来展开对接口的描述
       @PostMapping("/add")
       public String add(@RequestBody User user){
           return "add ok";
       }
   
       @ApiResponses(value = {
               @ApiResponse(responseCode = "404",description = "hhh404"),
               @ApiResponse(responseCode = "500",description = "hhhh500")})
       @GetMapping("/find/{id}")
       public User find(@PathVariable("id") int id){
           return new User(id,"user"+id);
       }
   
       @DeleteMapping("/delete/{id}")
       public String delete(@PathVariable("id") int id){
           return "delete ok";
       }
   
       @PutMapping("/put")
       public String update(@RequestBody User user){
           return "update ok";
       }
   
   }
   ```

   ```java
   @RestController
   public class HelloController {
   
       @RequestMapping("/hello")
       String hello(){
           return "hello";
       }
   
       @ApiIgnore //如果想在文档中屏蔽掉接口，那么只需要在方法上加上 @ApiIgnore 即可
       @GetMapping("/test")
       public String test(){
           return "test";
       }
   
   }
   ```

   







