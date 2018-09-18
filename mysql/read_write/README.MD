## 简介
准备部署mysql,这个样例是由**ConfigMap**,两个**Service**s和一个**StatefulSet**

### 创建 ConfigMap
```shell
[root@master ~]# kubectl create -f https://k8s.io/examples/application/mysql/mysql-configmap.yaml
configmap/mysql created
[root@master ~]# kubectl get ConfigMap
NAME      DATA      AGE
mysql     2         44s
```
这个配置文件能让你独立的去控制mysql的主节点与副节点。

### 创建 Services
通过下面的yaml配置文件来创建services
```shell
[root@master ~]# kubectl create -f https://k8s.io/examples/application/mysql/mysql-services.yaml
service/mysql created
service/mysql-read created
[root@master ~]# kubectl get services
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
mysql        ClusterIP   None             <none>        3306/TCP   14s
mysql-read   ClusterIP   10.106.212.177   <none>        3306/TCP   14s
```

### 创建 StatefulSet
最后，通过下面的yaml配置文件来创建services
```shell
kubectl create -f https://k8s.io/examples/application/mysql/mysql-statefulset.yaml

#异常
kubectl describe pods mysql-0
Events:
  Type     Reason            Age               From               Message
  ----     ------            ----              ----               -------
  Warning  FailedScheduling  4s (x23 over 1m)  default-scheduler  pod has unbound PersistentVolumeClaims (repeated 2 times)
```

**PersistentVolume**（持久卷，简称PV）是集群内，由管理员提供的网络存储的一部分。就像集群中的节点一样，PV也是集群中的一种资源。它也像 Volume 一样，是一种 volume 插件，但是它的生命周期却是和使用它的Pod相互独立的。PV这个API对象，捕获了诸如NFS、ISCSI、或其他云存储系统的实现细节。 


---------
- https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/ 部署mysql
- https://www.cnblogs.com/breezey/p/6582082.html configMap说明
- https://www.cnblogs.com/puyangsky/p/6677308.html mysql 
