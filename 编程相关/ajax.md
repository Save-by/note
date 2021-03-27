# ajax
>AJAX 是一种在无需重新加载整个网页的情况下，能够更新部分网页的技术。  

## 什么是 AJAX ？
(选自w3school)  
AJAX = 异步 JavaScript 和 XML。  
AJAX 是一种用于创建快速动态网页的技术。  
通过在后台与服务器进行少量数据交换，AJAX 可以使网页实现异步更新。这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。  
传统的网页（不使用 AJAX）如果需要更新内容，必需重载整个网页面。  
有很多使用 AJAX 的应用程序案例：新浪微博、Google 地图、开心网等等。  
## 常见知识点
> ajax主要是通过前端js的编写发起异步请求，后台Servlet的编写与普通的一致
1. 创建 XMLHttpRequest 对象
2. 向服务器发送请求**xmlhttp.open("GET","test1.txt",true); xmlhttp.send();**
3. 对服务器响应进行处理**使用 XMLHttpRequest 对象的 responseText 或 responseXML 属性。**（响应一般是json字符串）

|属性|描述|
|--|--|
|responseText|获得字符串形式的响应数据。|
|responseXML|获得 XML 形式的响应数据。|



```html
/**
 *例子如下
 */

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="/项目名/jquery-3.4.1.js"></script>

    <script type="text/javascript">

        //原生js
        function ajaxRequest() {
            //1.
            var xmlhttprequest = new XMLHttpRequest();

            //2.
            xmlhttprequest.open("GET","http://localhost:8080/项目名/Servlet名?method=方法名",true);

            //3.
            xmlhttprequest.onreadystatechange = function(){
                if(xmlhttprequest.readyState == 4 && xmlhttprequest.status == 200){
                    document.getElementById("jsdiv").innerText = "原生js的ajax"+ xmlhttprequest.responseText;
                }
            }

            //4.
            xmlhttprequest.send();
        }

        //jquery的写法
        $(function () {
            $("#jqAjax").click(function () {
                $.ajax({
                    url:"http://localhost:8080/项目名/Servlet名",
                    data:"method=方法名",
                    type:"GET",
                    success:function (msg) {
                        //var jsonObj = JSON.parse(msg);
                        $("#jqdiv").html("jQuery的ajax 年龄："+msg.age+"姓名："+msg.name) ;
                    },
                    dataType:"JSON"
                });
            });

        });

    </script>

<body>
    <button id="jsAjax" onclick="ajaxRequest()" >原生js的ajax</button>
    <button id="jqAjax" >jQuery的ajax</button><br/>

    <div id="jsdiv">jsdiv:</div>
    <div id="jqdiv">jquerydiv:</div>

</body>
</html>
```
## 需注意的地方
**异步请求浏览器地址栏不变**  
**在xmlhttp.open（）的第一个参数 用GET 还是 POST？**  
与 POST 相比，GET 更简单也更快，并且在大部分情况下都能用。  
然而，在以下情况中，请使用 POST 请求：

- 无法使用缓存文件（更新服务器上的文件或数据库）
- 向服务器发送大量数据（POST 没有数据量限制）
- 发送包含未知字符的用户输入时，POST 比 GET 更稳定也更可靠

**onreadystatechange 事件**  
当请求被发送到服务器时，我们需要执行一些基于响应的任务。  
每当 readyState 改变时，就会触发 onreadystatechange 事件。  
readyState 属性存有 XMLHttpRequest 的状态信息。  
下面是 XMLHttpRequest 对象的三个重要的属性：  

|属性|描述|
|---|---|
|onreadystatechange|存储函数（或函数名），每当 readyState 属性改变时，就会调用该函数。|
|readyState|存有 XMLHttpRequest 的状态。  从 0 到 4 发生变化。（ 0: 请求未初始化 1: 服务器连接已建立 2: 请求已接收 3: 请求处理中 4: 请求已完成，且响应已就绪）|
|status|200: "OK" 404: 未找到页面|

当Async = **true**时，**事件的绑定最好放在send()前**；当Async = **false**时（不推荐使用），将 open() 方法中的**第三个参数**改为 **false**，**不要编写 onreadystatechange 函数** - 把代码放到 send() 语句后面即可


## 其他发现
--