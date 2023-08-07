export VIP=10.1.1.230

export INTERFACE=ens33

KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")

alias kube-vip="docker run --network host --rm ghcr.io/kube-vip/kube-vip:$KVVERSION"

sudo chown -R devops:devops /etc/kubernetes

kube-vip manifest pod  --interface $INTERFACE  --address $VIP –controlplane --services     --arp     --leaderElection | tee /etc/kubernetes/manifests/kube-vip.yaml



#d - Bootstrap without shared endpoint
sudo sysctl -p

sudo kubeadm init --pod-network-cidr=172.24.0.0/16 --upload-certs --control-plane-endpoint=$VIP:6443

sudo chown $(id -u):$(id -g) $HOME/.kube/config
