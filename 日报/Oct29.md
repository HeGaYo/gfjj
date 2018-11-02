## 今日任务
- (已完成)将OADocker放到私有仓库中，可以通过ansible远程命令拉取对应的容器
- 根据不同的分支 来build不同的任务
- (已完成)继续看项目架构，删减部分缓存文件，容器大小减至800+MB
- ansible二次开发，看能不能搞

## 记录
1. 上传到私有仓库
```Dockerfile
$CONTAINER_NAME="oatest"
$VERSION="v1"
# push to the registry
docker tag oatest:latest 192.168.85.129:5000/$CONTAINER_NAME:$VERSION
docker push 192.168.85.129:5000/$CONTAINER_NAME:$VERSION
```

2. Sending build context to Docker daemon 传输内容太大怎么办
删减项目文件
- 各种缓存：D:\GF_2015_OA_8080\standalone\tmp\work\jboss.web\default-host\_\org\apache\jsp
10:24:10
宇轩 2018/10/29 10:24:10
人事档案图片：
程序部署目录/AppComponent/hr/da/photo/
证照图片：
程序部署目录/AppComponent/Certificant/BasicC/photo/
公共通讯录图片：
程序部署目录/AppComponent/myHelper/commonContacts/photo/
用户个性化设置涉及到的图片存放地址：
程序部署目录/AppComponent/homepage/personalstyleimages/
定存模板：
程序部署目录/GFProject/InvestFlowMana/TimeDeposit/depositmattach/
				/GFProject/InvestFlowMana/TimeDeposit/commitment/
QDII基金换汇模板：
程序部署目录/GFProject/FOS/QDII/exchange/template/
生成QDII基金换汇协议的临时目录：
程序部署目录/GFProject/FOS/QDII/exchange/ template_temp/
办公用品图片附件：
程序部署目录/GFProject/OfficeSuppliesManagemen/uploadfile/
正文编辑器图片：
程序部署目录/Legion/Platform/ThirdParty/edit/attached/image/
员工论坛常用表格文件：(使用过程中可能会进行增加和修改的维护)
程序部署目录/Legion/AppComponent/BBS/ CommTable/
投资研究的dbf文件生成临时目录


D:\GF_2015_OA_8080\standalone\tmp\vfs

```
git rm .
git commit -m 'update'
git push -u origin master
```

3. 拉取私有仓库镜像
```
docker pull 192.168.85.129:5000/oatest:v1
```
私有仓库：端口/image_name:tag

```
docker run -p 3000:8080 192.168.85.129:5000/oatest:v1
```

4. 通过ansible来管理远程主机，拉取镜像并且运行镜像容器


5. 添加了ansible组件，还没有尝试成功
