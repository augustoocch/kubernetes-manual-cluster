sudo kubeadm reset -f
sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml 
sudo rm /etc/kubernetes/manifests/kube-controller-manager.yaml 
sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml 
sudo rm /etc/kubernetes/manifests/etcd.yaml
sudo rm -rf /var/lib/etcd/*
