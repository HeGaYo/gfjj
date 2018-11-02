## 今日任务
- (已完成)了解整个项目的框架， 删减相关的文件，让项目安装包变小
- (已完成)编写Dockerfile构建跑OA系统的docker容器
- (未完成)搭建gitlab+jenkins+webhooks+docker环境

## 记录
- 项目框架
  尝试删掉了日志文件，减少了3+G。这日志文件也太多了吧。
  将项目压缩为tar.gz，这样的好处在于不用额外去下载unrar等解压工具。尝试放入到容器中,但是还要解压，导致容器又变大了。
  解决方案是直接在外面就解压好，然后利用Dockerfile的COPY或者ADD命令将文件夹复制到容器中。构建容器的时候会比较慢。

- docker容器
  - docker容器在ubuntu_backup虚拟机里中成功跑起来了。可以在页面上访问OA系统。并且可以进行端口重定向，`-p port1 port2 `这样一来我们与jenkins用的8080端口可以避开了。
  docker容器的那个文件夹是`/home/hgy/OADocker`，相关的文件都在里面。
  - 新增了expose的端口。端口配置的文件在`GF_2015_OA_8080\standalone\configuration\standalone.xml
`中。

  ```
  FROM ubuntu:14.04
  MAINTAINER Guoyan Huang <example@example.com>
  RUN apt-get update
  RUN mkdir /oa/
  RUN mkdir /oa/GF_2015_OA_8080
  ADD jdk-6u45-linux-x64.bin /oa/
  ADD buildJdk.sh /oa/
  ADD GF_2015_OA_8080 /oa/GF_2015_OA_8080
  ADD run.sh /oa/
  EXPOSE 9985 9986 9457 8017 8080 9579 6787 5827 5828 27
  CMD bash /oa/run.sh
  ```
  ```shell
  #!/bin/bash
  JDK_DIR="/usr/local/java"
  JDK_FILE="jdk-6u45-linux-x64.bin"
  CONFIG_FILE="/etc/profile"
  if [ -d $JDK_DIR ];then
  	rm -rf $JDK_DIR
  fi
  mkdir $JDK_DIR
  cd $JDK_DIR
  sudo cp /oa/$JDK_FILE  .
  sudo chmod 777 $JDK_FILE
  sudo ./$JDK_FILE
  JAVA_HOME="$JDK_DIR/jdk1.6.0_45"
  sed -i '/java/d'  $CONFIG_FILE
  sed -i '/jre/d' $CONFIG_FILE
  sed -i '/lib/d' $CONFIG_FILE
  sed -i '/bin:$PATH/d' $CONFIG_FILE
  echo "export JAVA_HOME=${JAVA_HOME}" >>$CONFIG_FILE
  echo 'export JRE_HOME=${JRE_HOME}/jre' >>$CONFIG_FILE
  echo 'export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib' >>$CONFIG_FILE
  echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> $CONFIG_FILE
  source /etc/profile
  java -version
  sudo update-alternatives --install /usr/bin/java java /usr/local/java/jdk1.6.0_45/bin/java 300  
  sudo update-alternatives --install /usr/bin/javac javac /usr/local/java/jdk1.6.0_45/bin/javac 300
  ```
  ```shell
  bash /oa/buildJdk.sh
  bash /oa/GF_2015_OA_8080/bin/standalone.sh > /dev/null
  echo "i am in the docker"
  ```
  - docker容器debug
  进入docker容器中的前提是这个docker容器正在运行。当然，我们也可以用`docker exec ...`或者`docker attach ...`
  ```
  docker run -it docker_ImageName /bin/bash
  ```

## 安装gitlab
参考链接
https://mirror.tuna.tsinghua.edu.cn/help/gitlab-ce/

```shell
curl https://packages.gitlab.com/gpg.key 2> /dev/null | sudo apt-key add - &>/dev/null
```
这里选择的是ubuntu14.04版本。
 在`/etc/apt/sources.list.d/gitlab-ce.list`中写入`deb https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu trusty main`
安装 gitlab-ce:
```shell
sudo apt-get update
sudo apt-get install gitlab-ce
```

设置gitlab和jenkens的连接
gitlab上生成private token
jenkins上填写这个gitlab api token
https://blog.csdn.net/zangxueyuan88/article/details/81195666?utm_source=blogxgwz1

gitlab修改其他主机可以访问

其他主机不能访问 明天解决这个问题

orz，原来是防火墙的问题。
```shell
sudo ufw status
sudo ufw allow http
sudo ufw allow OpenSSH
sudo ufw allow 11000 # 因为你改了端口，不再是80端口
```
