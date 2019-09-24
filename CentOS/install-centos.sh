#!/bin/sh
# We are installing the software repository for kubernetes
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# Now we are installing kubeadm and docker
yum install -y net-tools screen tree telnet kubelet kubeadm docker --nogpgcheck
# Below command will start docker and kubernetes agent i.e. kubelet on every system reboot
systemctl enable kubelet && systemctl start kubelet
systemctl enable docker && systemctl start docker
# We need to disable SELINUX and SWAP permanently
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
swapoff -a
sed -i '/swap/s/^/#/g' /etc/fstab
# Below command will fix a network issue with bridged adapter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
