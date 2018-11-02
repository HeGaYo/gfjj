## 今日任务
搭建github - jenkins - docker
## 记录
jenkins + jdk1.8 才可以运行
安装jenkins，可参考官网配置


jdk1.8下载地址
https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

jenkin部署 初始化密码在某个文件里，web页面上会提示
安装plugin 暂时选择推荐的plugin，有一些安装会失败
plugin安装如果失败的话，尝试重启，然后安装一次


目前实现的
github - jenkins - docker
1. 在github上放了项目的源代码
2. 我们在jenkins上新建一个item项目，填写git项目的地址链接，以及运行的脚本(大致的工作就是 下载github上的代码，去获取dockerfile，然后docker build构建容器， 再docker run运行容器)
3. 点击`build Now`, 界面上可以看到build History中生成一条记录。
4. 具体的输出我们可以看`Console Output`,success 或者 failed都有显示。
5. 当我们在github上提交了新的代码，有新的push之后要重新在jenkins上build一次，这样我们就可以得到最新的项目运行环境。

问题：
每次push后要手动去build，好麻烦。。。
据说gitlab + jenkins + webhook, 一旦有改动，就会自动build。实现代码自动部署集成。
