# 高颜值图书管理系统

![image-20250503004732636](./assets/image-20250503004732636.png)

![image-20250503005138773](./assets/image-20250503005138773.png)

![image-20250503005701284](./assets/image-20250503005701284.png)

![image-20250503005239596](./assets/image-20250503005239596.png)

![image-20250503005446577](./assets/image-20250503005446577.png)

![image-20250503005602032](./assets/image-20250503005602032.png)

### 项目使用环境

本项目是前后端分离开发的，前端使用 **VScode**，后端使用 **IDEA**。

- **JDK**: 1.8
  
- **Node.js**: 14.16.0  
  
- **MySQL**: 5.7.41  
  
- **Maven**: 3.6.1
  
- **Navicat**
  
  

> 注意：Node.js和MySQL这两个环境版本要一样，不然容易出问题。

### 后端部署

Navicat导入`book-manage-sys.sql`文件连接上本机数据库

后端项目名为 `books-manage-sys`，用 IDEA 打开后，配置好 Maven 。

![image-20250503005911461](./assets/image-20250503005911461.png)

点击运行按钮，后端启动。

![image-20250503010011469](./assets/image-20250503010011469.png)

### 前端部署

前端文件夹 `book-manage-sys-view`，用 VScode 打开。

右键 `src` 文件夹在集成终端中打开。

![前端终端](./assets/image-20250428144428438.png)

1. 先运行 `npm i` 命令，安装好相关依赖
2. 再运行 `npm run dev`

![前端启动](./assets/image-20250428144820165.png)

启动成功出现链接，可在浏览器运行。

![浏览器访问](./assets/image-20250428150245150.png)

### 账号信息

初始管理员账户：xiedaoyun/123456

初始读者用户：caiwenji/123456