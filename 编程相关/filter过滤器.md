# filter过滤器
>通常都是用来拦截request进行处理的，也可以对返回的response进行拦截处理
## 常见知识点
1. 创建方式与servlet类似，建类实现Filter接口
2. 使用 **@WebFilter** 注解就不用到web.xml中进行配置
3. doFilter方法为实现过滤的方法
4. urlPatterns配置要拦截的资源  
   以**指定资源**匹配。例如 **"/index.jsp"**  
   以**目录**匹配。例如 **"/servlet/*"**  
   以**后缀名**匹配，例如 **"*.jsp"**  
   通配符，拦截**所有web资源。"/*"**  


```java
/**
 *例子如下
 */

@WebFilter(filterName = "TestFilter",urlPatterns = "/*")
public class TestFilter implements Filter {
   
    public void destroy() {
        /*销毁时调用*/
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        /*过滤方法 主要是对request和response进行一些处理，然后交给下一个过滤器或Servlet处理*/
		if(XXX){

        }else{
            chain.doFilter(req, resp);//放行
        }
    }

    public void init(FilterConfig config) throws ServletException {
        /*初始化方法  接收一个FilterConfig类型的参数 该参数是对Filter的一些配置*/
    }

}
```
## 需注意的地方
1. 多个Filter对同一份资源过滤时，尽量避免逻辑关联，减少过滤器先后顺序问题  
>如果必须，多个Filter的执行顺序如下:
>- 在web.xml中，filter执行顺序跟<filter-mapping>的顺序有关，先声明的先执行
>- 使用注解配置的话，filter的执行顺序跟名称的字母顺序有关，例如AFilter会比BFilter先执行
>- 如果既有在web.xml中声明的Filter，也有通过注解配置的Filter，那么会优先执行web.xml中配置的Filter
2. Filter不会检查资源是否存在，只针对配置的拦截路径进行拦截

## 其他发现
在filter中添加try{}catch添加事务管理时,发现事务可以设置回滚位置
```java
/**
 *例子如下
 */

static void test() throws Exception {  
  Connection conn = null;  
  Savepoint sp = null;  
  try {     
  conn = JdbcUtils.getConnection();  
  //开启事务  
  conn.setAutoCommit(false);            
  XXXX
  //********************回滚界限***************************  
  //设置回滚点（savepoint）  
  sp = conn.setSavepoint();  
  //********************回滚界限***************************  
  XXXX
  //提交事务  
  conn.commit();  
  } catch (Exception e) {  
  if (conn != null && sp != null) {  
  //回滚事务，如果回滚的话只能回滚到savePoint以下的部分  
  //上面的部分不会得到回滚  
  conn.rollback(sp);  
  conn.commit();  
  }finally {  
  //释放资源 
  JdbcUtils.close(conn);  
  }  
}  
```