## 简介
configmap的使用方式可以查看官方样例

官方样例 https://kubernetes.io/docs/concepts/storage/volumes/#configmap

但是官网的样例写的简单，如下。
```
apiVersion: v1
kind: Pod
metadata:
  name: configmap-pod
spec:
  containers:
    - name: test
      image: busybox
      volumeMounts:
        - name: config-vol
          mountPath: /etc/config
  volumes:
    - name: config-vol
      configMap:
        name: log-config
        items:
          - key: log_level
            path: log_level
```

在官方样例中，使用了volume存储卷，从configMap来读取值。

由于我volume也不太了解，于是以官网样例为**configmap-pod.yaml**以及新建**log-config.yaml**,来进行测试。

## 进行测试

### 第一步:创建 **configmap-pod.yaml**
```shell
[root@master ~]# kubectl create -f configmap-pod.yaml 
pod/configmap-pod created
[root@master ~]# kubectl exec -it pod/configmap-pod bash
error: invalid resource name "pod/configmap-pod": [may not contain '/']
[root@master ~]# kubectl get po
NAME            READY     STATUS              RESTARTS   AGE
configmap-pod   0/1       ContainerCreating   0          1m
[root@master ~]# kubectl describe pod/configmap-pod
.....
Events:
  Type     Reason       Age               From               Message
  ----     ------       ----              ----               -------
  Normal   Scheduled    1m                default-scheduler  Successfully assigned default/configmap-pod to node
  Warning  FailedMount  47s (x8 over 1m)  kubelet, node      MountVolume.SetUp failed for volume "config-vol" : configmaps "log-config" not found

```
> 无法找到log-config，所以我们需要自己创建configMap

### 第二步:创建 **log-config.yaml**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: log-config
data:
   log_level: "1"
```
> 请注意**log_level: "1"**这个不能写成**log_level: "1"**,否则会报

> Error from server (BadRequest): error when creating "configmap.yaml": ConfigMap in version "v1" cannot be handled as a ConfigMap: v1.ConfigMap.ObjectMeta: v1.ObjectMeta.TypeMeta: Kind: Data: ReadString: expects " or n, but found 1, error found in #10 byte of ...|g_level":1},"kind":"|..., bigger context ...|{"apiVersion":"v1","data":{"log_level":1},"kind":"ConfigMap","metadata":{"name":"log-confi|...

创建

```shell
## 
[root@master ~]# kubectl create -f configmap.yaml 
configmap/log-config created
```
查看configmap 的文件log-config的详细情况
```shell
[root@master ~]# kubectl describe configmap/log-config
Name:         log-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
log_level:
----
1
Events:  <none>

[root@master ~]# kubectl get configmap
NAME         DATA      AGE
log-config   1         59m

```
> 通过 **kubectl describe** 可以查看出**log_level**的值

### 第三步：重新创建第一步的**configmap-pod.yaml**
因为开始创建第一步失败，所以重新创建第一步的**configmap-pod.yaml**

```shell
[root@master ~]# kubectl create -f configmap-pod.yaml 
pod/configmap-pod created
```

### 第四步：最终查看结果

进入容器内部进行查看
```shell
[root@master ~]# kubectl exec -it configmap-pod bash
root@configmap-pod:/# cat /etc/config/log_level 
1
```

> 如果发现得出的结果是1，代表成功.