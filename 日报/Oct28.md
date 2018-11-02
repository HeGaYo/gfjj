## 今日任务
- （已完成）通过jenkins自动构建一个OADocker，并且能够跑起来，写shell脚本。
- 根据不同的分支 来build不同的任务？
- 继续看项目架构
- ansible docker-py

## 记录
编写了相关的shell文件来编译
```shell
#!/bin/sh
id
set +e
echo '>>> Get old container id'

CID=$(docker ps | grep "oatest" | awk '{print $1}')

echo $CID

docker build -t oatest /var/lib/jenkins/workspace/OADocker | tee /var/lib/jenkins/workspace/OADocker/Docker_build_result.log
RESULT=$(cat /var/lib/jenkins/workspace/OADocker/Docker_build_result.log | tail -n 1)

#if [["$RESULT" != *Successfully*]];then
#  exit -1
#fi

echo '>>> Stopping old container'

if [ "$CID" != "" ];then
  docker stop $CID
fi

echo '>>> Restarting docker'
sudo service docker restart
sleep 10

echo '>>> Starting new container'
docker run -p 3000:8080 -d oatest

echo "successfully download OADocker"
```


ubuntu部署ansible
```shell
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```

添加host
配置文件在`/etc/ansible/hosts`.
可以修改`/etc/hosts`
```shell
ansible ubuntu_backup -m ping
ansible ubuntu_backup -m shell -a "echo hello world |tee /tmp/helloworld"
```

docker私有仓库
```shell
docker run -d -v /opt/registry:/var/lib/registry -p 5000:5000 --restart=always --name registry registry
docker tag hwapp:v2 192.168.85.129:5000/hwapp:v3
docker push 192.168.85.129:5000/hwapp:v3
```

设置私有仓库的源
```shell
touch /etc/docker/daemon.json
echo '{ "insecure-registries":  ["192.168.85.129:5000"] }' > /etc/docker/daemon.json
service docker restart
```
将容器镜像放到私有仓库中
然后通过ansible的命令让远程主机去拉取对应的容器
  * 拉取容器
  `sudo docker pull 192.168.85.129:5000/ubuntu:v4`
  * 启动容器


ansible 已经移除了 docker模块


Ansible Container 使你能够构建容器镜像并使用 Ansible playbook 进行编排。该程序在一个 YAML 文件中描述，而不是使用 Dockerfile，列出组成容器镜像的 Ansible 角色

最尴尬的方法就是直接用
ansible -m shell -a ...
