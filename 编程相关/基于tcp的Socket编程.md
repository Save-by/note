# 基于tcp的Socket编程

1. 特点

   - 面向有连接
   - 数据量大，以**字节流**形式传输
   - 通过三次握手，协议可靠

2. 编程思想

   - 建立套接字(socket)

     它允许程序把网络连接看成一个流(stream)，可以向这个流写字节，也可以从这个流读取字节。

   - 监听

   - 建立连接

   - 通信

   - 关闭IO流、Socket

## Client（客户端）

- 建立套接字

  ```java
  Socket(IneAddress address/*服务器的IP地址*/,int port/*端口号*/)
  ```

- 建立连接

  - IN

  ```java
  getInputStream()//返回字节输入流对象
  InputStreamReader(InputStream in)//将字节流转换为（单个）字符
  BufferedReader(Reader in)//缓冲字符输入流
  ```

  - OUT

  ```java
  getOutputStream()//返回字节输出流对象
  PrintWriter(Writer out)//字符类型打印输出流
  ```

  

- 通信

  ```java
  readLine()//等待接收数据，自能读取一行
  ```

  

- 关闭IO流、Socket

  ```java
  close()
  ```

  

## Server（服务端）

- 建立套接字

  ```java
  ServerSocket(int port)
  ```

- 监听

  ```java
  accept()
  ```

- 建立连接

  ```java
  //同CLient
  ```

- 通信

  ```java
  //同CLient(方法相同，具体实现看自己设计)
  ```

- 关闭IO流、Socket

  ```java
  //同CLient
  ```

## 问题

在不使用多线程的情况下，只能实现简单的一问一答而不能单方多次输出（不知道是不是我菜），所以在源码中有多线程的部分



> 以下为源码

```java
//server部分

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

public class Server {
    public static void main(String[] args) {
        System.out.println("服务器开始运行");
        try {
            ServerSocket serverSocket = new ServerSocket(6666);

            while(true){
                Socket socket = serverSocket.accept();

                new Thread(new ServerListen(socket)).start();
                new Thread(new ServerSend(socket)).start();
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

/**
 * 监听
 */
class ServerListen implements Runnable{
    private Socket socket;

    public ServerListen(Socket socket) {
        this.socket = socket;
    }

    @Override
    public void run() {
        try {
            ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
            Object obj;
            while(true){
                obj = ois.readObject();
                if(!("(Heart):心跳测试".equals(obj))){
                    System.out.println(obj);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }finally {

            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            
        }
    }
}

/**
 * 发送
 */
class ServerSend implements Runnable{
    private Socket socket;

    public ServerSend(Socket socket) {
        this.socket = socket;
    }

    @Override
    public void run() {
        try {
            ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
            Scanner scanner = new Scanner(System.in);
            while(true){
                System.out.println("(Server):");
                String string = "(Server):" + scanner.nextLine();


                oos.writeObject(string);
                oos.flush();
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

//-----------------------------------------------------------------------------------------------

//client部分
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Scanner;

public class Client1 {
    /**
     * socket
     */
    public static Socket socket;
    /**
     * 连接状态码
     */
    public static boolean connState = false;
    /**
     * 输出流
     */
    public static ObjectOutputStream oos;
    /**
     * 输入流
     */
    public static ObjectInputStream ois;


    public static void main(String[] args) throws Exception {
        //尝试第一次连接
        while(!connState){
            reConnect();
            //线程休息3秒
            //Thread.sleep(3000);
        }
    }

    /**
     * 连接方法
     */
    private static void connect(){
        try {
            socket = new Socket("127.0.0.1",6666);
            connState = true;

            oos = new ObjectOutputStream(socket.getOutputStream());
            ois = new ObjectInputStream(socket.getInputStream());

            //建立多线程避免堵塞
            new Thread(new ClientListen(socket,ois)).start();
            new Thread(new ClientSend(socket,oos)).start();
            new Thread(new ClientHeart(socket,oos)).start();

        } catch (IOException e) {
            e.printStackTrace();
            connState = false;
        }
    }

    /**
     * 断开时重连
     */
    public static void reConnect(){
        System.out.println("正在尝试重连。。。");
        connect();
        try {
            //线程休息3秒
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

/**
 * 监听
 */
class ClientListen implements Runnable{
    private Socket socket;
    ObjectInputStream ois ;

    public ClientListen(Socket socket,ObjectInputStream ois) {
        this.socket = socket;
        this.ois = ois;
    }

    @Override
    public void run() {
        try {
            
            //打印输入内容
            while(true){
                System.out.println(ois.readObject());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

/**
 * 发送
 */
class ClientSend implements Runnable{
    private Socket socket;
    private ObjectOutputStream oos;

    public ClientSend(Socket socket, ObjectOutputStream oos) {
        this.socket = socket;
        this.oos = oos;
    }

    @Override
    public void run() {
        try {

            Scanner scanner = new Scanner(System.in);

            while(true){
                //键盘输入
                System.out.println("(Client):");
                String string = "(Client):" + scanner.nextLine();

                //输出键入的内容
                oos.writeObject(string);
                //刷新缓冲
                oos.flush();
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {

                socket.close();
                Client1.connState = false;
                Client1.reConnect();

            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}

/**
 * 心跳测试（检查连接是否断开）
 */
class ClientHeart implements Runnable{

    private Socket socket;
    private ObjectOutputStream oos;

    public ClientHeart(Socket socket ,ObjectOutputStream oos) {
        this.socket = socket;
        this.oos = oos;
    }

    @Override
    public void run() {
        try {
            System.out.println("心跳测试已开始");

            while(true){
                //线程休息5秒
                Thread.sleep(5000);
                String string = "(Heart):心跳测试";

                oos.writeObject(string);
                oos.flush();
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {

                socket.close();
                Client1.connState = false;
                Client1.reConnect();

            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}
```

