## 简介
Kubernetes集群管理员通过提供不同的存储类，可以满足用户不同的服务质量级别、备份策略和任意策略要求的存储需求。动态存储卷供应使用StorageClass进行实现，其允许存储卷按需被创建。如果没有动态存储供应，Kubernetes集群的管理员将不得不通过手工的方式类创建新的存储卷。通过动态存储卷，Kubernetes将能够按照用户的需要，自动创建其需要的存储。

基于StorageClass的动态存储供应整体过程如下图所示：
![](1.png)

- 集群管理员预先创建存储类（StorageClass）；
- 用户创建使用存储类的持久化存储声明(PVC：PersistentVolumeClaim)；
- 存储持久化声明通知系统，它需要一个持久化存储(PV: PersistentVolume)；
- 系统读取存储类的信息；
- 系统基于存储类的信息，在后台自动创建PVC需要的PV；
- 用户创建一个使用PVC的Pod；
- Pod中的应用通过PVC进行数据的持久化；
- 而PVC使用PV进行数据的最终持久化处理。


参考文章
- https://blog.qikqiak.com/post/kubernetes-persistent-volume2/