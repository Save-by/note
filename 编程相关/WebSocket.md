# WebSocket

## 1.与springboot组合

1. ```java
   @Component
   public class WebSocketConfig  {
       /**
        * ServerEndpointExporter 作用
        *
        * 这个Bean会自动注册使用@ServerEndpoint注解声明的websocket endpoint
        *
        * @return
        */
       @Bean
       public ServerEndpointExporter serverEndpointExporter(){
           return new ServerEndpointExporter();
       }
   }
   ```

2. ```java
   import com.by.entry.User;
   import com.google.gson.Gson;
   import org.springframework.stereotype.Component;
   
   
   import javax.websocket.*;
   import javax.websocket.server.ServerEndpoint;
   import java.io.IOException;
   import java.util.concurrent.CopyOnWriteArraySet;
   
   
   @ServerEndpoint("/websocket")
   @Component
   public class WebSocket {
       //静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
       private static Integer onlineCount = 0;
   
       //concurrent包的线程安全，用来存放每个客户端对应的MyWebSocket对象。
       private static CopyOnWriteArraySet<WebSocket> webSocketSet = new CopyOnWriteArraySet<>();
   
       private User user;
       private Session session;
   
       private static Gson gson = new Gson();
   
       @OnOpen
       public void onOpen(Session session) throws IOException {
   
           this.session = session;
           webSocketSet.add(this);
           addOnlineCount();
           this.session.getBasicRemote().sendText("有新连接加入！当前在线人数为"+getOnlineCount());
   
       }
   
       @OnClose
       public void onClose() throws IOException {
          webSocketSet.remove(this);
          subOnlineCount();
          System.out.println("有新连接退出！当前在线人数为"+getOnlineCount());
       }
   
       @OnMessage
       public void onMessage (Session session,String message) throws IOException {
           //这里可以区分群发或单发，示例只简单使用群发
           for (WebSocket w : webSocketSet) {
               //转化为对象
               User user = gson.fromJson(message, User.class);
               //....具体逻辑操作....
   
               //发送信息
               w.session.getBasicRemote().sendText(gson.toJson(user));
           }
       }
   
       @OnError
       public void onError(Session session, Throwable error) {
           try {
               session.getBasicRemote().sendText("发生错误啦");
           } catch (IOException e) {
               e.printStackTrace();
           }
           error.printStackTrace();
       }
   
   
       public static synchronized int getOnlineCount() {
           return onlineCount;
       }
   
       public static synchronized void addOnlineCount() {
           onlineCount++;
       }
   
       public static synchronized void subOnlineCount() {
           onlineCount--;
       }
   
   ```

3. 前端关键

   ```html
   <!DOCTYPE HTML>
   <html>
   <head>
       <title>My WebSocket</title>
   </head>
   
   <body>
   Welcome<br/>
   <input id="text" type="text" /><button onclick="send()">Send</button>    <button onclick="closeWebSocket()">Close</button>
   <div id="message">
   </div>
   </body>
   
   <script type="text/javascript">
       var websocket = null;
   
       //判断当前浏览器是否支持WebSocket
       if('WebSocket' in window){
           websocket = new WebSocket("ws://localhost:8080/websocket");
       }
       else{
           alert('Not support websocket')
       }
   
       //连接发生错误的回调方法
       websocket.onerror = function(){
           setMessageInnerHTML("error");
       };
   
       //连接成功建立的回调方法
       websocket.onopen = function(event){
           setMessageInnerHTML("open");
       }
   
       //接收到消息的回调方法
       websocket.onmessage = function(event){
           setMessageInnerHTML(event.data);
       }
   
       //连接关闭的回调方法
       websocket.onclose = function(){
           setMessageInnerHTML("close");
       }
   
       //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
       window.onbeforeunload = function(){
           websocket.close();
       }
   
       //将消息显示在网页上
       function setMessageInnerHTML(innerHTML){
           document.getElementById('message').innerHTML += innerHTML + '<br/>';
       }
   
       //关闭连接
       function closeWebSocket(){
           websocket.close();
       }
   
       //发送消息
       function send(){
           var message = document.getElementById('text').value;
           var obj = {
               "userId":12315,
               "userName": "zhangshang",
               "message":message
           }
           websocket.send(JSON.stringify(obj));
       }
   </script>
   </html>
   ```

   