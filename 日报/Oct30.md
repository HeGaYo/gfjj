## 今日任务
- 根据不同的分支 来build不同的任务
- (已完成)jenkins搭配ansible来用，可以重复跑job
- (已完成)私有仓库的使用.md

## 记录
1. jenkins+ansible插件：
刚开始在jenkins上一直无法执行ansible的命令，加了ansible插件，或者是写在shell脚本里都不行。
但是自己在命令行下却可以成功执行，究其原因还是用户权限的问题。我们执行jenkins的用户名是jenkins，但是执行ansible的那些命令却是用root或者hgy。因此可能会有权限隔离的问题。有两个解决方案。
  - 修改ansible.cfg文件，然后去掉注释ansible_user=root，也就是说每次执行的时候都是用root用户来执行。不过对我这个问题好像没什么用。
  - 第二种就是su jenkins，切换到jenkins用户下，下载ssh，并且将公钥注入到远程主机。再去执行job，就成功了。

2. 使得job可以重复执行
不然你的端口会被绑定，导致你不能运行新的job
通过ansible删除当前正在运行的容器，并且启动新的容器

```shell
#!/bin/sh
id
set +e
echo "****************************step1*********************************"
echo "build new images"
docker build -t oatest /var/lib/jenkins/workspace/OADocker | tee /var/lib/jenkins/workspace/OADocker/Docker_build_result.log
RESULT=$(cat /var/lib/jenkins/workspace/OADocker/Docker_build_result.log | tail -n 1)

echo "****************************step2*********************************"
echo "stop old containers and delete old images on the remote host"
ansible ubuntu -m ping
CID=$(ansible ubuntu -m shell -a "docker ps" |grep "oatest" | awk '{print $1}')
echo $CID
if [ "$CID" != "" ];then
  ansible ubuntu -m shell -a "docker stop $CID"
  ansible ubuntu -m shell -a "docker rm $CID"
fi
IMGID=$(ansible ubuntu -m shell -a "docker images" |grep "oatest" | awk '{print $3}')
echo $IMGID
if [ "$IMGID" != "" ];then
  ansible ubuntu -m shell -a "docker rmi $IMGID"
fi

echo "****************************step3*********************************"
echo "push new images to the registry"
docker tag oatest:latest 192.168.85.129:5000/oatest:v1
docker push 192.168.85.129:5000/oatest:v1

echo "****************************step4*********************************"
echo "pull images from remote registry"
ansible ubuntu -m shell -a "docker pull 192.168.85.129:5000/oatest:v1"
ansible ubuntu -m shell -a "docker images"

echo "****************************step5*********************************"
echo "start the container and get the log info"
ansible ubuntu -m shell -a "docker run -p 3000:8080 -d 192.168.85.129:5000/oatest:v1"
CID=$( docker ps | grep "oatest" | awk '{print $1}')
ansible ubuntu -m shell -a "docker logs $CID"

echo "****************************done*********************************"
```
