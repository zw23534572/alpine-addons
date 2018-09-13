# 常用命令
kubectl get pod,deployment,svc -n kube-system
kubectl logs -f pod/kube-apiserver-node -n kube-system
kubectl logs -f pod/kube-controller-manager-node -n kube-system
kubectl logs -f pod/kube-flannel-ds-5whjw -n kube-system
kubectl logs -f pod/kube-proxy-xdpvt -n kube-system
kubectl logs -f pod/kube-scheduler-node -n kube-system
kubectl logs -f pod/kubernetes-dashboard-78dc5f9d6b-vq4dl -n kube-system


#获取dashboard 的token
# 输入下面命令查询kube-system命名空间下的所有secret
kubectl get secret -n kube-system
# 然后获取token。只要是type为service-account-token的secret的token都可以使用。
# 比如我们获取replicaset-controller-token-wsv4v的touken
kubectl -n kube-system describe replicaset-controller-token-wsv4v
## 这里有一个简单的命令：
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token