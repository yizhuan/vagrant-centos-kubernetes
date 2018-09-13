# OS Info
CentOS box
Username: root
Password: vagrant

```
[root@master kernel]# cat /etc/centos-release
CentOS Linux release 7.5.1804 (Core)
```

# Vagrant Centos kubernetes cluster
- docker 1.13.1
- kubeadm 1.11

```
[root@master ~]# kubectl get pods --all-namespaces -o=wide
NAMESPACE     NAME                             READY     STATUS    RESTARTS   AGE       IP                NODE      NOMINATED NODE
kube-system   coredns-78fcdf6894-7xzqc         1/1       Running   0          24m       10.244.0.2        master    <none>
kube-system   coredns-78fcdf6894-lrztv         1/1       Running   0          24m       10.244.0.3        master    <none>
kube-system   etcd-master                      1/1       Running   0          23m       192.168.100.20    master    <none>
kube-system   kube-apiserver-master            1/1       Running   0          23m       192.168.100.20    master    <none>
kube-system   kube-controller-manager-master   1/1       Running   0          23m       192.168.100.20    master    <none>
kube-system   kube-flannel-ds-amd64-6r748      1/1       Running   0          17m       192.168.100.22   node-2    <none>
kube-system   kube-flannel-ds-amd64-gn4nk      1/1       Running   0          24m       192.168.100.20    master    <none>
kube-system   kube-flannel-ds-amd64-s2j9t      1/1       Running   1          21m       192.168.100.21   node-1    <none>
kube-system   kube-proxy-bwcfx                 1/1       Running   0          17m       192.168.100.22   node-2    <none>
kube-system   kube-proxy-cnlgv                 1/1       Running   0          24m       192.168.100.20    master    <none>
kube-system   kube-proxy-g8hl5                 1/1       Running   0          21m       192.168.100.21   node-1    <none>
kube-system   kube-scheduler-master            1/1       Running   0          23m       192.168.100.20    master    <none>
```

## plugins
- flannel

## Prerequisites 
- Vagrant 2.1.4 (with NFS support)

#### Note for Windows

- The vagrant-winnfsd plugin will be installed in order to enable NFS shares.
- The project will run some bash script under the VirtualMachines. These scripts line ending need to be in LF. Git for windows set ```core.autocrlf``` true by default at the installation time. When you clone this project repository, this parameter (set to true) ask git to change all line ending to CRLF. This behavior need to be changed before cloning the repository (or after for each files by hand). We recommand to turn this to off by running ```git config --global core.autocrlf false``` and ```git config --global core.eol lf``` before cloning. Then, after cloning, do not forget to turn the behavior back if you want to run other windows projects: ```git config --global core.autocrlf true``` and ```git config --global core.eol crlf```.

## Installation
```bash
git clone https://github.com/yizhuan/vagrant-centos-kubernetes.git
cd vagrant-centos-kubernetes/
vagrant up
```
## Clean-up
```bash
vagrant destroy -f
```

## Configuration
config.rb
```ruby
# If you change, Keep the structure with the dot. [0-9 a-f]
$token = "56225f.9096af3559802a6a"
# Total memory of master
$master_memory = 1536
# Increment to have more nodes
$worker_count = 2
# Total memory of nodes
$worker_memory = 1536
# Add Grafana with InfluxDB (work with heapster)
$grafana = false
```

### Basic usage
```bash
# Note : You need to have kubectl on the host
# http://kubernetes.io/docs/user-guide/prereqs/
# Or use ssh (vagrant ssh master)
# Cluster info
kubectl cluster-info
# Get nodes
kubectl get nodes
# Get system pods
kubectl get pods --namespace=kube-system
## Full documentation : http://kubernetes.io/docs/
```
