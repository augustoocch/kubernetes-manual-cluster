#Steps 1 and 2 must be done manually

#3 - Disable swapoff.  (hacer en todas las maquinas)
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


#4- Forward IPv4 y and let iptables see connected traffic
#Execute the below mentioned instructions:
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter



# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

#5 - Apply sysctl params without reboot
sudo sysctl –system


#6 - Verify that the br_netfilter, overlay modules are loaded by running the following #commands:


lsmod | grep br_netfilter
lsmod | grep overlay


#7 - Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, #and net.ipv4.ip_forward system variables are set to 1 in your sysctl config by #running the following command:
 

sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward



# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

#8 - Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

# Install required packages
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

#9 - Add Docker repo
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
#--------------------------------------------------------------------
  
#Call script 2
sudo sh ./installScript-02.sh


  
