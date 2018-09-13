#!/bin/sh

TOKEN=$4
echo 'INSTALL KUBERNETES'
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo setenforce 0
sudo sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

#enable ssh login for convenience when debugging 
sudo sed -i 's@PasswordAuthentication no@PasswordAuthentication yes@g' /etc/ssh/sshd_config
sudo service sshd restart

#turn off swap
sudo swapoff -a
sudo sed -i 's@/dev/mapper/VolGroup00-LogVol01 swap@#/dev/mapper/VolGroup00-LogVol01 swap@g' /etc/fstab

yum install -y ipvsadm
sudo modprobe br_netfilter
sudo modprobe ip_vs_wrr
sudo modprobe ip_vs_sh
sudo modprobe ip_vs
sudo modprobe ip_vs_rr

sudo echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

yum install -y docker kubelet kubeadm kubectl kubernetes-cni wget ntp

#enable time synchronization
systemctl start ntpd
systemctl enable ntpd

systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet

if [ "$1" == "-master" ]; then
    kubeadm init --apiserver-advertise-address=$2 --pod-network-cidr=10.244.0.0/16 --token=$TOKEN
 
  sudo mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
 
  cp /etc/kubernetes/admin.conf /shared
 
  ##for using WeaveNet
  ##kubectl --kubeconfig /shared/admin.conf apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
 
  kubectl --kubeconfig /shared/admin.conf create -f "https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
 
elif [ "$1" == "-node" ]; then
 echo "I AM A NODE"
  rm -Rf /etc/kubernetes/*
  kubeadm join $2:6443 --token=$TOKEN --discovery-token-unsafe-skip-ca-verification
  if [ "$3" == "-last" ]; then
    ##Do something here if needed
    echo "..."
  fi
fi
echo "Wait 10.00s" && sleep 10