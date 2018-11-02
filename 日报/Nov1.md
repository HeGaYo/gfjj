## 今日任务
- (已完成)思考下昨天提出的那几个点，做哪些，怎么做
  - svn与gitlab的区别，迁移项目需要做什么，有什么注意的点
  - 应用升级与数据库升级的区别
  应用升级：代码层面
  数据库升级：对表的增删改查，字段添加删除修改
  - 考虑主机扩容的情况
  参照原来的实现，可以考虑用负载均衡来实现。
- （已完成）oadev跑成功

## 记录
```shell
#!/bin/sh
id
set +e
echo "--------------------------------------------------------------------------------------------"
echo "*****************************************step1**********************************************"
echo "--------------------------------------------------------------------------------------------"
echo "build new images"
docker build -t oadev /var/lib/jenkins/workspace/OADev | tee /var/lib/jenkins/workspace/OADev/Docker_build_result.log
RESULT=$(cat /var/lib/jenkins/workspace/OADev/Docker_build_result.log | tail -n 1)
echo "--------------------------------------------------------------------------------------------"
echo "*****************************************step2**********************************************"
echo "--------------------------------------------------------------------------------------------"
echo "stop old containers and delete old images on the remote host"
ansible ubuntu -m ping
CID=$(ansible ubuntu -m shell -a "docker ps" |grep "oadev" | awk '{print $1}')
echo $CID
if [ "$CID" != "" ];then
  ansible ubuntu -m shell -a "docker stop -f $CID"
  ansible ubuntu -m shell -a "docker rm -f $CID"
fi

ansible ubuntu -m shell -a "docker images"
IMGID=$(ansible ubuntu -m shell -a "docker images" |grep "oadev" | awk '{print $3}')
echo $IMGID
if [ "$IMGID" != "" ];then
  ansible ubuntu -m shell -a "docker rmi -f $IMGID"
fi
echo "after deleting the docker images"
ansible ubuntu -m shell -a "docker images"
echo "--------------------------------------------------------------------------------------------"
echo "*****************************************step3**********************************************"
echo "--------------------------------------------------------------------------------------------"
echo "push new images to the registry"
docker tag oadev:latest 192.168.85.129:5000/oadev:v1
docker push 192.168.85.129:5000/oadev:v1
echo "--------------------------------------------------------------------------------------------"
echo "*****************************************step4**********************************************"
echo "--------------------------------------------------------------------------------------------"
echo "pull images from remote registry"
ansible ubuntu -m shell -a "docker pull 192.168.85.129:5000/oadev:v1"
ansible ubuntu -m shell -a "docker images"
echo "--------------------------------------------------------------------------------------------"
echo "*****************************************step5**********************************************"
echo "--------------------------------------------------------------------------------------------"
echo "start the container and get the log info"
ansible ubuntu -m shell -a "docker run -p 3080:8080 -d --restart=always -v /opt/data/oadev/oalog:/oa/GF_2015_OA_8080/standalone/log 192.168.85.129:5000/oadev:v1"
#看日志
#CID=$(ansible ubuntu -m shell -a "docker ps" |grep "oadev" | awk '{print $1}')
#ansible ubuntu -m shell -a "docker logs $CID"
echo "--------------------------------------------------------------------------------------------"
echo "*****************************************done**********************************************"
echo "--------------------------------------------------------------------------------------------"
```
