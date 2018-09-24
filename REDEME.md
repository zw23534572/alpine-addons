## 简介
alpine-addons的组件集成所有的k8s的配置。

请按步骤依次来进行安装

- alpine-addons/deploy [k8s-启动与安装]
- alpine-addons/dashboard [k8s-ui访问，其中还包括Heapster+Grafana+InfluxDB]
- alpine-addons/mysql [k8s-mysql-启动与安装,主从方式的也有，但是未落地]
- alpine-addons/configMap [使用方式]
- alpine-addons/storageClass [使用方式]
- alpine-addons/volumes [使用方式]

## Deployment
- Replication Controller run一个来保证可用性，但是由于是无状态的,与之前挂载的Volume失去联系。
- StatefulSet 状态可以保留Volume联系

## 常用命令
```shell
kubectl get po                          # 查看目前所有的pod
kubectl get rs                          # 查看目前所有的replica set
kubectl get deployment                  # 查看目前所有的deployment
kubectl get service                     # 查看目前所有的service
kubectl describe po my-nginx            # 查看my-nginx pod的详细状态
kubectl describe rs my-nginx            # 查看my-nginx replica set的详细状态
kubectl describe deployment my-nginx    # 查看my-nginx deployment的详细状态
kubectl delete svc example-service example-service-nodeport
kubectl delete deploy nginx curl 
kubectl get pod,deployment,svc -n kube-system
kubectl logs -f pod/kube-apiserver-node -n kube-system
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
```

## ImagePullPolicy
支持三种ImagePullPolicy
- Always：不管镜像是否存在都会进行一次拉取。
- Never：不管镜像是否存在都不会进行拉取
- IfNotPresent：只有镜像不存在时，才会进行镜像拉取。
注意：
- 默认为IfNotPresent，但:latest标签的镜像默认为Always。
- 拉取镜像时docker会进行校验，如果镜像中的MD5码没有变，则不会拉取镜像数据。
- 生产环境中应该尽量避免使用:latest标签，而开发环境中可以借助:latest标签自动拉取最新的镜像。

## 测试访问方式
```shell
## 开启url镜像
kubectl run curl --image=radial/busyboxplus:curl -i --tty
nslookup kubernetes
nslookup example-service
curl example-service

kubectl get po
kubectl attach curl-87b54756-gxnzw -c curl -i -t
```
