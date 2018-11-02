## 今日任务
- 了解整个项目的框架（未完成）
- 搭建gitlab+jenkins+webhooks+docker环境(未完成)
- 编写Dockerfile构建跑OA系统的docker容器(出错)

## 记录
### linux搭建项目部署环境
复制bin文件到虚拟机中。

安装jdk6的shell脚本参考资料
https://blog.csdn.net/u013027996/article/details/32916085

卸载jdk6的shell脚本,脚本需要可以重复执行

```shell
#!/bin/bash
JDK_DIR="/usr/local/java"
JDK_FILE="jdk-6u45-linux-x64.bin"
CONFIG_FILE="/etc/profile"
if [ -d $JDK_DIR ];then
	rm $JDK_DIR
fi
mkdir $JDK_DIR
cd $JDK_DIR
sudo cp /home/hgy/Downloads/$JDK_FILE  .
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
复制OA系统rar文件压缩包到虚拟机中
安装unrar，解压rar文件
```shell
sudo apt-get install unrar
cd /home/hgy/Downloads/
unrar x ./GF_2015_OA_8080.rar
```

执行运行脚本

```shell
cd /home/hgy/GF_2015_OA_8080/
sudo bash bin/standalone.sh
```

访问页面看是否成功部署
http://127.0.0.1:8080

### 构建OA系统的docker
因为oa系统的压缩包有点大，所以在构建的时候可能会有space问题。
然后现在遇到的是镜像仓库的问题，无法连接到那边。可能要重新配置。问题在哪里呢...
