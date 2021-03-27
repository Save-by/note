# MyBatisPlus

## 快速入门

使用spring boot整合

1. 主方法添加扫描

   ```java
   @SpringBootApplication
   @MapperScan("com.by.mapper")//添加扫描
   public class ParkingAdminApplication {
   
       public static void main(String[] args) {
           SpringApplication.run(ParkingAdminApplication.class, args);
       }
   
   }
   ```

2. 导依赖

   ```xml
   <!--数据库驱动-->
   <dependency>
       <groupId>mysql</groupId>
       <artifactId>mysql-connector-java</artifactId>
   </dependency>
   <!--mybatis-plus-->
   <dependency>
       <groupId>com.baomidou</groupId>
       <artifactId>mybatis-plus-boot-starter</artifactId>
       <version>3.0.5</version>
   </dependency>
   <!--连接池-->
   <dependency>
       <groupId>com.alibaba</groupId>
       <artifactId>druid</artifactId>
       <version>1.1.17</version>
   </dependency>
   <!--lombok-->
   <dependency>
       <groupId>org.projectlombok</groupId>
       <artifactId>lombok</artifactId>
       <optional>true</optional>
   </dependency>
   ```

3. 数据库连接配置(application.properties)

   ```properties
   spring.datasource.url= jdbc:mysql://localhost:3306/数据库?serverTimezone=UTC
   spring.datasource.username=root
   spring.datasource.password=123456
   spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
   spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
   #使用application.yaml文件格式在idea中使用测试模块会出现无法检测到配置的情况
   ```

4. 实体类

   ```java
   @Data
   @AllArgsConstructor
   @NoArgsConstructor
   public class TRole {
       private Integer id;
       private Integer roleId;
       private String  roleName;
   }
   ```

5. 接口

   ```java
   @Repository
   public interface RoleMapper extends BaseMapper<TRole> {
   }
   ```

6. 测试连接

   ```java
   @SpringBootTest
   class ParkingAdminApplicationTests {
       @Autowired
       private RoleMapper roleMapper;
   
       @Test
       void contextLoads() {
           List<TRole> tRoles = roleMapper.selectList(null);
           tRoles.forEach(System.out::println);
       }
   }
   ```



## 配置日志

1. application.properties

   ```properties
   #配置日志输出(这里使用控制台输出)
   mybatis-plus.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl 
   ```




## CRUD及扩展

### 插入

> 数据库插入的id的默认值为：全局的唯一id

#### 主键生成策略

分布式系统唯一ID生成方案汇总：https://www.cnblogs.com/haoxinyue/p/5208136.html

雪花算法：

snowflake是Twitter开源的分布式ID生成算法，结果是一个long型的ID。其核心思想是：使用41bit作为毫秒数，10bit作为机器的ID（5个bit是数据中心，5个bit的机器ID），12bit作为毫秒内的流水号（意味着每个节点在每毫秒可以产生 4096 个 ID），最后还有一个符号位，永远是0。具体实现的代码可以参看https://github.com/twitter/snowflake。

1. 实体类

```java
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TUser {
    @TableId(type = IdType.AUTO)//设置主键生成的策略
    private Integer userId;
    private String userName;
}

//注解中对应的枚举值意义
public enum IdType {
    //数据库ID自增
    AUTO(0),
    //该类型为未设置主键类型
    NONE(1),
    //用户输入ID
    //该类型可以通过自己注册自动填充插件进行填充
    INPUT(2),

    /* 以下3种类型、只有当插入对象ID 为空，才自动填充。 */
    //全局唯一ID (idWorker)
    ID_WORKER(3),
    //全局唯一ID (UUID)
    UUID(4),
    //字符串全局唯一ID (idWorker 的字符串表示)
    ID_WORKER_STR(5);

    private int key;

    private IdType(int key) {
        this.key = key;
    }

    public int getKey() {
        return this.key;
    }
}
```

2. 测试代码

```java
@Test
    void insert() {
        //插入
        TUser tUser = new TUser();
        tUser.setUserName("用户14");

        int insert = userMapper.insert(tUser);
        // 1
        System.out.println(insert);
        //TUser(userId=14, userName=用户14)，这里会把生成的主键设置进去
        System.out.println(tUser);

    }
```

### 更新

1. 测试代码

```java
@Test
void update() {
    //插入
    TUser tUser = new TUser();
    tUser.setUserId(12);
    tUser.setUserName("用户12更新后");

    //根据id修改
    int i = userMapper.updateById(tUser);
    //1
    System.out.println(i);
    //TUser(userId=12, userName=用户12更新后)
    System.out.println(tUser);

}
```

### 自动填充

创建时间、修改时间，这些一般都是自动化完成的

> 方法一：数据库级别

在表中添加列于设置

![image-20210202130457405](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20210202130457405.png)

更新实体类对应字段

```java
private Date creatTime;
private Date updateTime;
```

> 方法二：代码级别（常用）

1. 删除数据库的默认值设置与更新

2. 在实体类对应字段增加注解

   ```java
   @Data
   @NoArgsConstructor
   @AllArgsConstructor
   public class TUser {
       //设置主键生成的策略
       @TableId(type = IdType.AUTO)
       private Integer userId;
       private String userName;
   
       //设置插入时记录时间
       @TableField(fill = FieldFill.INSERT)//fill是字段自动填充策略
       private Date creatTime;
       //设置更新时记录时间
       @TableField(fill = FieldFill.INSERT_UPDATE)
       private Date updateTime;
   }
   
   //注解属性对应枚举
   public enum FieldFill {
       //默认不处理
       DEFAULT,
       //插入填充字段
       INSERT,
       //更新填充字段
       UPDATE,
       //插入和更新填充字段
       INSERT_UPDATE
   }
   ```

3. 自定义元数据处理器MyMetaObjectHandler

   ```java
   import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
   import lombok.extern.slf4j.Slf4j;
   import org.apache.ibatis.reflection.MetaObject;
   import org.springframework.stereotype.Component;
   
   import java.util.Date;
   
   @Slf4j
   @Component
   public class MyMetaObjectHandler implements MetaObjectHandler {
       //插入时的填充策略
       @Override
       public void insertFill(MetaObject metaObject) {
           log.info("start insert fill ...");
           //根据字段名填充值
           //MetaObjectHandler setFieldValByName(String fieldName, Object fieldVal, MetaObject metaObject)
           this.setFieldValByName("creatTime",new Date(),metaObject);
           this.setFieldValByName("updateTime",new Date(),metaObject);
       }
   
       //更新时的填充策略
       @Override
       public void updateFill(MetaObject metaObject) {
           log.info("start update fill ...");
           //根据字段名填充值
           this.setFieldValByName("updateTime",new Date(),metaObject);
       }
   }
   ```

   

### 乐观锁

1. 数据库添加version字段

   ![image-20210202135734727](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20210202135734727.png)

2. 实体类添加对应属性

   ```java
   @Version//乐观锁version注解
   private Integer version;
   ```

3. 注册组件

   ```java
   //mybatis-plus3.0.5版本，最新的好像不需要注册了
   @MapperScan("com.by.mapper")//在这里添加扫描包注解后，就可以不用在主方法添加这个注解了
   @EnableTransactionManagement //自动开启事务管理
   @Configuration //配置类
   public class MyBatisPlusConfig {
   
       //注册乐观锁插件
       @Bean
       public OptimisticLockerInterceptor optimisticLockerInterceptor(){
           return new OptimisticLockerInterceptor();
       }
   }
   ```



### 查询

```java
@Autowired
private UserMapper userMapper;

@Test
void select() {
    System.out.println("################################");
    //查询所有
    System.out.println("查询所有");
    List<TUser> userList = userMapper.selectList(null);
    userList.forEach(System.out::println);

    System.out.println("################################");
    //根据id查询
    System.out.println("根据id查询");
    TUser user = userMapper.selectById(12);
    System.out.println(user);
    
    System.out.println("################################");
    //根据id批量查询
    System.out.println("根据id批量查询");
    List<TUser> userList1 = userMapper.selectBatchIds(Arrays.asList(3, 5, 6));
    userList1.forEach(System.out::println);
    
    System.out.println("################################");
    //按条件查询方法一：使用map进行
    System.out.println("按条件查询方法一：使用map进行");
    Map<String, Object> map = new HashMap<>();
    map.put("version",2);//表示查询用户version为2的行
    List<TUser> userList2 = userMapper.selectByMap(map);
    userList2.forEach(System.out::println);


}
```



### 分页查询

1. 原始的limit进行分页
2. pageHelper第三方插件
3. MP内置的分页插件

> 使用

1. 配置拦截器组件

   ```java
   @MapperScan("com.by.mapper")//在这里添加扫描包注解后，就可以不用在主方法添加这个注解了
   @EnableTransactionManagement //自动开启事务管理
   @Configuration //配置类
   public class MyBatisPlusConfig {
   
       //注册分页插件
       @Bean
       public PaginationInterceptor paginationInterceptor(){
           return new PaginationInterceptor();
       }
   }
   ```

2. 使用

   ```java
   @Test
   void pageSelect() {
       //参数1：当前页，参数2：页面大小
       Page<TUser> user = new Page<>(2,5);//表示第2页，查询5条
       System.out.println("######1");
       user.getRecords().forEach(System.out::println);
       System.out.println("before");
       IPage<TUser> tUserIPage = userMapper.selectPage(user, null);
       System.out.println("######2");
       user.getRecords().forEach(System.out::println);//这里的user与tUserIPage一样
       System.out.println("######3");
       tUserIPage.getRecords().forEach(System.out::println);
   }
   ```



### 删除

#### 真正删除

```java
@Test
void delete() {
    //根据id删除
    int i = userMapper.deleteById(14);
    System.out.println(i);
    //根据id批量删除
    int i1 = userMapper.deleteBatchIds(Arrays.asList(8, 9, 10));
    System.out.println(i1);
    //使用map做条件进行删除
    HashMap<String, Object> map = new HashMap<>();
    map.put("user_id",6);
    int i2 = userMapper.deleteByMap(map);
    System.out.println(i2);
}
```



#### 逻辑删除

1. 数据库增加字段

   ![image-20210202154731236](C:\Users\HP\AppData\Roaming\Typora\typora-user-images\image-20210202154731236.png)

2. 对应实体类增加属性与注解

   ```java
   @TableLogic//逻辑删除注解
   private Integer deleted;
   ```

3. 配置application.yml

   ```yml
   mybatis-plus:
     global-config:
       db-config:
         logic-delete-field: deleted  # 全局逻辑删除的实体字段名(since 3.3.0,配置后可以忽略不配置步骤2)
         logic-delete-value: 1 # 逻辑已删除值(默认为 1)
         logic-not-delete-value: 0 # 逻辑未删除值(默认为 0)
   ```

4. 注册组件

   ```java
   //注册逻辑删除（3.1.1后不再需要注册）
   @Bean
   public ISqlInjector iSqlInjector(){
       return new LogicSqlInjector();
   }
   ```

注：在逻辑删除后查询会自动过滤被删除的



### 性能分析插件

1. 注册插件

   ```java
   //性能分析插件
   @Bean
   @Profile({"dev","test"})//设置dev test 环境开启
   public PerformanceInterceptor performanceInterceptor(){
       PerformanceInterceptor performanceInterceptor = new PerformanceInterceptor();
       //这里设置为1ms
       performanceInterceptor.setMaxTime(1);//单位ms 设置sql语句执行最大时间，超过就不执行，停止服务
       performanceInterceptor.setFormat(true);//格式化输出
       return performanceInterceptor;
   }
   ```

2. 配置开发环境application.properties

   ```properties
   #配置开发环境
   spring.profiles.active=dev
   ```

3. 测试使用

### 条件构造器

```java
@Test
void select() {
    //查询userName不为空，id大于等于10，version小于等于1的值
    QueryWrapper<TUser> wrapper = new QueryWrapper<>();
    wrapper
        .isNotNull("user_name")
        .ge("user_id",10)
        .le("version",1);

    userMapper.selectList(wrapper).forEach(System.out::println);
}
```



### 代码生成器

1. 添加依赖

```xml
<!--代码生成器-->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-generator</artifactId>
    <version>3.0.5</version>
</dependency>

<!--模板-->
<dependency>
    <groupId>org.apache.velocity</groupId>
    <artifactId>velocity-engine-core</artifactId>
    <version>2.2</version>
</dependency>

```

2. 代码

```java
import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.po.TableFill;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;

import java.util.Arrays;

/**
 * 代码生成器
 * @author yly
 * @date 2021/2/2 17:20
 */

public class AutoCode {
    public static void main(String[] args) {
        //需要构建一个 代码生成器 对象
        AutoGenerator mpg = new AutoGenerator();
        //配置策略

        //1.全局配置
        GlobalConfig gc = new GlobalConfig();
        String projectPath = System.getProperty("user.dir");//项目路径
        gc.setOutputDir(projectPath + "/src/main/java");//代码生成路径
        gc.setAuthor("by");//设置作者
        gc.setOpen(false);//取消生成后打开的操作
        gc.setFileOverride(false);//取消文件覆盖
        gc.setServiceName("%sService");//去I前缀
        gc.setIdType(IdType.AUTO);//设置主键填充策略
        gc.setDateType(DateType.ONLY_DATE);//设置时间填充策略
        gc.setSwagger2(true);//swagger

        mpg.setGlobalConfig(gc);

        //2.配置数据源
        DataSourceConfig dsc = new DataSourceConfig();
        dsc.setDriverName("com.mysql.cj.jdbc.Driver");
        dsc.setUrl("jdbc:mysql://localhost:3306/数据库名称?serverTimezone=UTC");
        dsc.setUsername("root");
        dsc.setPassword("123456");
        dsc.setDbType(DbType.MYSQL);

        mpg.setDataSource(dsc);

        //3.包的配置
        PackageConfig pc = new PackageConfig();
        //pc.setModuleName("blog");
        pc.setParent("com.by");
        pc.setEntity("entity");
        pc.setMapper("mapper");
        pc.setService("service");
        pc.setController("controller");

        mpg.setPackageInfo(pc);

        //4.策略配置
        StrategyConfig sc = new StrategyConfig();
        sc.setInclude("t_user","t_task","t_type");//包含需要映射的表名
        sc.setNaming(NamingStrategy.underline_to_camel);
        sc.setColumnNaming(NamingStrategy.underline_to_camel);
        //sc.setSuperEntityClass("你自己的父类实体,没有就不用设置!");
        sc.setEntityLombokModel(true);
        //sc.setRestControllerStyle(true);
        //sc.setControllerMappingHyphenStyle(true);//开启路径下划线命名
        //sc.setControllerMappingHyphenStyle(false);
        sc.setLogicDeleteFieldName("deleted");//设置逻辑删除
        //自动填充配置
        //TableFill creatTime = new TableFill("creat_time", FieldFill.INSERT);
        //TableFill updateTime = new TableFill("update_time", FieldFill.INSERT_UPDATE);
        //sc.setTableFillList(Arrays.asList(creatTime,updateTime));
        //乐观锁
        //sc.setVersionFieldName("version");

        mpg.setStrategy(sc);

        //执行
        mpg.execute();
    }
}
```





























