## 简介
K8S的存储系统从基础到高级又大致分为三个层次：
- 普通Volume
- Persistent Volume
- 动态存储供应(dynamic provisioning)。

### 普通Volume
  - emptyDir,是一个匿名的空目录，由Kubernetes在创建Pod时创建，删除Pod时删除.
    样例如下
    ```shell
    apiVersion: v1
    kind: Pod
    metadata:
      name: test-pd
    spec:
      containers:
      - image: nginx:1.7.9
        name: test-container
        volumeMounts:
        - mountPath: /cache
          name: cache-volume
      volumes:
      - name: cache-volume
        emptyDir: {}
    ```
  - hostPath,存储临时数据或用于在同一个Pod里的容器之间共享数据。
  样例如下
    ```shell
    apiVersion: v1
    kind: Pod
    metadata:
      name: test-pd
    spec:
      containers:
      - image: nginx:1.7.9
        name: test-container
        volumeMounts:
        - mountPath: /test-pd
          name: test-volume
      volumes:
      - name: test-volume
        hostPath:
          # directory location on host
          path: /data
    ```

### 跨节点存储卷
这种存储卷不和某个具体的K8S节点绑定，而是独立于K8S节点存在的，整个存储集群和K8S集群是两个集群，相互独立。

跨节点的存储卷在Kubernetes上用的比较多，如果已有的存储不能满足要求，还可以开发自己的Volume插件，只需要实现Volume.go 里定义的接口。


#### rbd
  rbd卷可以将Rados Block Device设备映射到pod中。当Pod被移除时，emptyDir卷的内容会被清空，和emptyDir不同，rbd卷的内容还存在着，仅仅是卷被卸载掉而已。也就是说，rbd卷可以其上的数据一起，再次被映射，数据也可以在pod之间传递。 
  
  重要：在使用rbd卷之前，你必须先安装Ceph环境。 

  RBD的一个特性就是能够以只读的方式同时映射给多个用户使用。不幸的是，rbd卷只能被一个用户已可读写的模式映射——不能同时允许多个可写的用户使用。 

#### cephfs

  cephfs卷可以将已经存在的CephFS卷映射到pod中。与rbd卷相同，当pod被移除时，cephfs卷的内容还存在着，仅仅是卷被卸载掉而已。另外一点不同的是，CephFS可以同时以可读写的方式映射给多个用户。 

### Persistent Volume
**Persistent Volume** 简称PV是一个K8S资源对象，所以我们可以单独创建一个PV。它不和Pod直接发生关系，而是通过**Persistent Volume Claim**，简称PVC来实现动态绑定。Pod定义里指定的是PVC，然后PVC会根据Pod的要求去自动绑定合适的PV给Pod使用。

- PV的访问模式
  - **RWO – ReadWriteOnce** 是最基本的方式，可读可写，但只支持被单个Pod挂载
  - **ROX – ReadOnlyMany** 可以以只读的方式被多个Pod挂载。
  - **RWX – ReadWriteMany** 这种存储可以以读写的方式被多个Pod共享。不是每一种存储都支持这三种方式，像共享方式，目前支持的还比较少，比较常用的是NFS。在PVC绑定PV时通常根据两个条件来绑定，一个是存储的大小，另一个就是访问模式。
- PV的回收策略
  - **Retain** – 手动重新使用
  - **Recycle** – 基本的删除操作 ("rm -rf /thevolume/*")
  - **Delete** – 关联的后端存储卷一起删除，后端存储例如AWS EBS, GCE PD或OpenStack Cinder
- 卷的状态
  - **Available** –闲置状态，没有被绑定到PVC
  - **Bound** – 绑定到PVC
  - **Released** – PVC被删掉，资源没有被在利用
  - **Failed** – 自动回收失败

参考资料
- https://kubernetes.io/docs/concepts/storage/volumes/ 官网介绍
- https://blog.csdn.net/styshoo/article/details/69496952 Kubernetes volumes简介