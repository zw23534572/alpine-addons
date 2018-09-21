## 简介
创建单节点的k8s mysql服务器,用于学习的参考

### 部署mysql-rc
创建文件mysql-rc.yaml
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: mysql
spec:
  replicas: 1
  selector:
    app: mysql                      #符合目标的Pod拥有此标签
  template:
    metadata:
      labels:
        app: mysql                  #Pod副本拥有的标签，对应RC的Selector
    spec:
      containers:
      - name: mysqlpod
        image: mysql:5.7            #容器对应的Docker image
        ports:
        - containerPort: 3306
        env:                        #注入容器内的环境变量
        - name: MYSQL_ROOT_PASSWORD #容器应用监听的端口号
          value: "123456"
```
执行mysql-rc.yaml
```shell
[root@master test]# kubectl create -f mysql-rc.yaml 
replicationcontroller/mysql created
```
查看rc是否创建
```shell
[root@master test]# kubectl get rc
NAME      DESIRED   CURRENT   READY     AGE
mysql     1         1         1         6m
```
查看pod是否创建

### 部署mysql-service
创建mysql-svc.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql #Service的全局唯一名称
spec:
  ports:
  - port: 3306
  selector: #Service对应的Pod拥有这里定义的标签
    app: mysql
```
执行shell
```shell
[root@master test]# kubectl create -f mysql-svc.yaml
service/mysql created
```
查看servcie是否创建
```shell
[root@master test]# kubectl get service -o wide
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE       SELECTOR
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP          7d        <none>
mysql        NodePort    10.106.217.13   <none>        3306:30000/TCP   8s        app=mysql
```

### navicat 测试
目前对外开放的端口为**30000**，在navicat连接的信息为
```ini
connection name: <主机名>--随便填写
Host name/IP Address: <主机的外网ip>
Port: 30000
User Name: root
Password: 123456
```

> 请注意，目前所有数据都是保存在mysql容器内，那就代表说如果mysql容器挂了，
在开启的时候的所有mysql的数据都会丢失.

### 通过存储卷保存mysql的数据
在**mysql-rc.yaml**添加代码或者重新创建一个新的rc，我的样例名称暂定为**mysql-host-path-rc.yaml**
```shell
....添加文件映射
        volumeMounts:
        - name: db
          mountPath: /var/lib/mysql
      volumes:
        - name: db
          hostPath:
            # directory location on host
            path: /var/lib/mysql
```
执行shell
```shell
[root@master ~]# kubectl delete -f mysql-rc.yaml 
replicationcontroller "mysql" deleted
[root@master ~]# kubectl delete -f mysql-svc.yaml
service "mysql" deleted
[root@master ~]# kubectl create -f mysql-host-path-rc.yaml 
replicationcontroller/mysql created
[root@master ~]# kubectl create -f mysql-svc.yaml 
service/mysql created
```

> 再进行测试的时候，发现刚才创建的所有数据库都还在。
原因为：**/var/lib/mysql**已经被映射到宿主机**/var/lib/mysql**,所以原始的数据依然存在。

请注意

这个是针对单个node节点，但是k8s不可能只有一个node节点，所有每次删除mysql的容器，再次发布时会到发布到一台机器。也就是说每个node进行的挂载是它本地的硬盘。这样的话，数据就不会保持一致。

解决办法

- 1.每次重新发布mysql都指定在对应的node机器。
- 2.用网络磁盘来解决。

本章直介绍单个节点的mysql的部署。

