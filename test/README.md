## 所有的镜像存在于我的阿里云系统
1.登录阿里云Docker Registry
```shell
sudo docker login --username=zw17763713260 registry.cn-shenzhen.aliyuncs.com
```

### 将镜像推送到Registry
```shell
$ sudo docker login --username=zw17763713260 registry.cn-shenzhen.aliyuncs.com
$ sudo docker tag e8804ac30df4 registry.cn-shenzhen.aliyuncs.com/sjroom/spring-boot-web
$ sudo docker push registry.cn-shenzhen.aliyuncs.com/sjroom/apline-java8:[镜像版本号]
```
