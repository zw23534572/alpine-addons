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