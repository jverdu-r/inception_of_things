#!/bin/bash

# Set the colors for displaying information in the terminal

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Install net-tools for ifconfig command
if sudo apt update && sudo apt install -y net-tools; then
    echo -e "${GREEN}net-tools installed successfully${RESET}"
else
    echo -e "${RED}Failed to install net-tools${RESET}"
    exit 1
fi

# Eliminar token viejo para evitar conflictos
sudo rm -f /vagrant/token.env

# Creating an environment variable for installing the master node
# https://docs.k3s.io/installation/configuration#configuration-file

if export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san 192.168.56.110 --node-ip 192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "; then
    echo -e "${GREEN}export INSTALL_K3S_EXEC SUCCEEDED${RESET}"
else
    echo -e "${RED}export INSTALL_K3S_EXEC FAILED${RESET}"
fi

# Install master node
# https://docs.k3s.io/quick-start

if curl -sfL https://get.k3s.io | sh -; then
    echo -e "${GREEN}K3s MASTER installation SUCCEEDED${RESET}"
else
    echo -e "${RED}K3s MASTER installation FAILED${RESET}"
    exit 1
fi

# Esperar a que K3s esté completamente operativo
echo -e "${GREEN}Waiting for K3s to be fully operational...${RESET}"
sleep 20
for i in {1..30}; do
    if sudo k3s kubectl get nodes > /dev/null 2>&1; then
        echo -e "${GREEN}K3s is fully operational!${RESET}"
        break
    fi
    echo "Attempt $i/30: K3s not ready yet..."
    sleep 2
done

# Copying the Vagrant token to the mounted folder, which will be necessary to install the worker
# https://docs.k3s.io/quick-start

if sudo cat /var/lib/rancher/k3s/server/token > /vagrant/token.env; then
    echo -e "${GREEN}TOKEN SUCCESSFULLY SAVED${RESET}"
else
    echo -e "${RED}TOKEN SAVING FAILED${RESET}"
fi

# The command "sudo ip link" add eth1 type dummy creates a virtual network interface named eth1
# The command "sudo ip addr" add 192.168.56.110/24 dev eth1 assigns the IP address 192.168.56.110 with a subnet mask of /24
# The final part, sudo ip link set eth1 up, activates the eth1 interface.

if sudo ip link add eth1 type dummy && sudo ip addr add 192.168.56.110/24 dev eth1 && sudo ip link set eth1 up; then
    echo -e "${GREEN}add eth1 SUCCEESSFULLY${RESET}"
else
    echo -e "${RED}add eth1 FAILED${RESET}"
fi
