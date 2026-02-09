#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN}=== STARTING K3s SERVER INSTALLATION ===${RESET}"

# 1️⃣ Actualizar e instalar curl
if sudo apt update && sudo apt install -y curl; then
    echo -e "${GREEN}Dependencies installed successfully${RESET}"
else
    echo -e "${RED}Failed to install dependencies${RESET}"
    exit 1
fi

# 2️⃣ Exportar variable INSTALL_K3S_EXEC
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --node-ip=192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}INSTALL_K3S_EXEC exported successfully${RESET}"
else
    echo -e "${RED}Failed to export INSTALL_K3S_EXEC${RESET}"
    exit 1
fi

# 3️⃣ Instalar K3s server
if curl -sfL https://get.k3s.io | sh -; then
    echo -e "${GREEN}K3s server installed successfully${RESET}"
else
    echo -e "${RED}K3s server installation failed${RESET}"
    exit 1
fi

# 4️⃣ Guardar token para worker
if sudo cat /var/lib/rancher/k3s/server/token > /vagrant/token.env; then
    echo -e "${GREEN}Token saved to /vagrant/token.env${RESET}"
else
    echo -e "${RED}Failed to save token${RESET}"
    exit 1
fi

# 5️⃣ Verificar K3s server
if sudo k3s kubectl get nodes; then
    echo -e "${GREEN}K3s server is running${RESET}"
else
    echo -e "${RED}K3s server is not running${RESET}"
fi
