## 简介
因为我们 kubernetes 版本为 v1.6.2 所以我们选择对应的 Dashboard 版本为 v1.6.+ 即可，版本也不要太新，否则可能会出现兼容性问题。不过可以使用 v1.6.0+ 的版本，它开始支持中文了，更直观一些哈。
```shell
kubectl create -f kubernetes-dashboard.yaml
```

## 创建nginx-rc.yaml文件
## 查看token
```shell
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token
kubectl get po -n kube-system
kubectl logs pods/heapster-7c9cff9f8-rxtkr -n kube-system
kubectl logs pods/kubernetes-dashboard-68ff5fcd99-w9wgk  -n kube-system
kubectl logs pods/monitoring-grafana-77db8c878f-lc82f   -n kube-system
kubectl logs pods/monitoring-influxdb-7f7f87658-5kngn  -n kube-system

```




访问方式
```shell
kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$'

http://120.79.189.147:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
http://193.112.125.239:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWo2ZDViIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiIzM2I0MGE5OC1iNjZjLTExZTgtYTczNS0wMDE2M2UwZTc5NjUiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.Zy62UcAD9eObeOr2hNcifJiFX1wWHnjabWhIGdOtuCwjS1W-6Er6cmscZiYz3zmSg3k6bwp0jwu855djGRDNU_PZoFcoJSysUSf4-0ImOYAfKH-skQ_ahrvimab7zqe3bnkf7eeZvSH-xv3PHIUbzT03dcMnOuq3LMamExrZGix8PatjdRlbSvAzmwQThlW8ALQmJj4KYaIWXasJ91PqFEI2-_9MKeCvrgRqOdmlPawjxoc43NxYsk33Rbi7nkMUZzRUQ1iw6Apn3-jZXInQlxS1NOLpdGkrmK_R08kPZ4zC5Z4BWCvXNFyCJp5NFFtE9muD0pRy-_MhwtB1YUmeoA

```

https://www.cnblogs.com/RainingNight/p/deploying-k8s-dashboard-ui.html

## 安装插件
### 整合heapster和influxdb


https://120.79.189.147:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
https://193.112.125.239:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

 --test-type --ignore-certificate-errors

# 参考文档
- https://www.cnblogs.com/RainingNight/p/deploying-k8s-dashboard-ui.html  kubernetes-dashboard(1.8.3)部署与踩坑
- http://blog.51cto.com/ylw6006/2113542 K8S使用dashboard管理集群
- http://www.cnblogs.com/scode2/p/8810052.html 详解k8s一个完整的监控方案(Heapster+Grafana+InfluxDB) - kubernetes
- http://www.mamicode.com/info-detail-2247805.html  详解k8s一个完整的监控方案(Heapster+Grafana+InfluxDB) - kubernetes
- https://blog.csdn.net/aixiaoyang168/article/details/78411511 国内使用 kubeadm 在 Centos 7 搭建 Kubernetes 集群