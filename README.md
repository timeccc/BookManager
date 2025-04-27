![](https://cdn.nlark.com/yuque/0/2025/png/51928112/1745765888037-951f0e33-c19b-4ed9-a906-d597f25c70a5.png)

![](https://cdn.nlark.com/yuque/0/2025/png/51928112/1745766010430-6c157892-f537-487a-bb9f-aa9217c48113.png)

![](https://cdn.nlark.com/yuque/0/2025/png/51928112/1745765908250-41f67db2-bd54-4ae8-88a7-ae70cdfeca52.png)

## 项目软件环境
**MySQL：v5.7.41**

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1720374716444-73dc79c6-47d3-4fa7-96bd-619260df550c.png?x-oss-process=image%2Fformat%2Cwebp)

**Node.js：v14.16.0**

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1720375954307-b631cc21-3f9a-4ebd-8bcb-75278ec92f6d.png)

这两个**版本要一样**！高版本或者版本不同，大概率跑不起来，出问题！

<font style="color:rgb(38, 38, 38);"></font>

## **<font style="color:rgb(38, 38, 38);">数据库部署</font>**
### <font style="color:rgb(38, 38, 38);"></font>**<font style="color:rgb(38, 38, 38);">Navicat连接上本机数据库</font>**
#### <font style="color:rgb(38, 38, 38);"></font>![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438321351-7ea35e78-b066-4fd8-aae4-e3516671cb68.png?x-oss-process=image%2Fformat%2Cwebp)
新建数据库

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438420678-b93757bb-8915-46b6-8896-991c00466d0f.png?x-oss-process=image%2Fformat%2Cwebp)

新建数据库并导入SQL文件

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438477075-ea1244fc-ccb4-4f7e-8a7a-c31fe6b21e7d.png?x-oss-process=image%2Fformat%2Cwebp)

导入

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438524901-9b788fce-e85d-4d89-ab99-9d60148af958.png?x-oss-process=image%2Fformat%2Cwebp)



![](https://cdn.nlark.com/yuque/0/2025/png/51928112/1745765753106-e9930bd0-09d3-4359-b040-07d2793f8dcd.png)

导入成功

## 后端部署

### 导入后端项目![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438743076-e439b397-1e0d-491f-a765-5e478645c51d.png?x-oss-process=image%2Fformat%2Cwebp)IDEA里面导入

配置Maven

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438715095-d407f3b3-dfce-428d-9b9f-1ce53e3d138b.png?x-oss-process=image%2Fformat%2Cwebp)

项目环境

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438831431-de1d5000-5893-48d7-a8ca-22265ca75e11.png?x-oss-process=image%2Fformat%2Cwebp)



![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438885418-c1ea3307-e058-4adf-a42c-36f35e15b9a1.png?x-oss-process=image%2Fformat%2Cwebp)

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438888947-6d082a46-b765-4872-bb47-75f73c5e6079.png?x-oss-process=image%2Fformat%2Cwebp)

###  配置数据库连接

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725438997667-ee2808da-23bb-415d-a332-ca83952f9d6e.png?x-oss-process=image%2Fformat%2Cwebp)

### 运行后端项目

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725439072612-59572622-dfba-496e-9c3e-c2fa32633f89.png?x-oss-process=image%2Fformat%2Cwebp)

前端项目

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725439134398-33be4884-4cbd-4588-9a1d-c9db572f38eb.png?x-oss-process=image%2Fformat%2Cwebp)

VScode打开前端文件夹

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725439169760-dc59b3e5-9b44-4337-9e41-963867112d63.png?x-oss-process=image%2Fformat%2Cwebp)

src目录下，鼠标右键，打开终端

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725439209138-4ce70b56-dc1c-40ec-947c-78b71b60ae79.png?x-oss-process=image%2Fformat%2Cwebp)

终端里面，输入npm i 指令，安装前端依赖。

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725439342097-20e0f875-7982-4dd9-b667-c4e8677cbffc.png?x-oss-process=image%2Fformat%2Cwebp)

依赖安装完成之后，执行npm run dev运行项目。

![](https://cdn.nlark.com/yuque/0/2024/png/32649796/1725439406239-10fc526a-b547-41df-861e-4d45d4e745d3.png?x-oss-process=image%2Fformat%2Cwebp)

拿着链接去浏览器运行

![](https://cdn.nlark.com/yuque/0/2025/png/51928112/1745765864101-0efa716b-62f7-4143-a534-5737af7d42af.png)

浏览器出现登录页面，代表登录成功。  
管理员初始账号密码：xiaoyan/123456

