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
### 测试
```shell
# 测试pod-volume
kubectl create -f https://raw.githubusercontent.com/zw23534572/alpine-addons/master/test/pod-volume.yaml
# 测试pod
kubectl create -f https://raw.githubusercontent.com/zw23534572/alpine-addons/master/test/pod.yaml
# 测试pod-env
kubectl create -f https://raw.githubusercontent.com/zw23534572/alpine-addons/master/test/pod-env.yaml
# 测试pod-limit
kubectl create -f https://raw.githubusercontent.com/zw23534572/alpine-addons/master/test/pod-limit.yaml
# 测试pod-heath-check
kubectl create -f https://raw.githubusercontent.com/zw23534572/alpine-addons/master/test/pod-heath-check.yaml
# 测试pod-init-container
kubectl create -f https://raw.githubusercontent.com/zw23534572/alpine-addons/master/test/pod-init-container.yaml
# 指定 nodes机器进行启动
kubectl label nodes <your-node-name> disktype=ssd
kubectl create -f https://raw.githubusercontent.com/zw23534572/alpine-addons/master/test/pod-special-node.yaml
```