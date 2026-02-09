#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN}=== STARTING K3s WORKER INSTALLATION ===${RESET}"

# 0️⃣ Detener cualquier agent previo
sudo systemctl stop k3s-agent 2>/dev/null
sudo pkill k3s-agent 2>/dev/null

# 1️⃣ Actualizar e instalar curl
if sudo apt update && sudo apt install -y curl; then
    echo -e "${GREEN}Dependencies installed successfully${RESET}"
else
    echo -e "${RED}Failed to install dependencies${RESET}"
    exit 1
fi

# 2️⃣ Verificar que el token del master existe
if [ -f /vagrant/token.env ]; then
    TOKEN=$(cat /vagrant/token.env)
    echo -e "${GREEN}Token read successfully${RESET}"
else
    echo -e "${RED}Token not found. Is the master ready?${RESET}"
    exit 1
fi

# 3️⃣ Exportar variable INSTALL_K3S_EXEC con la IP correcta
export INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 --token=$TOKEN --node-ip=192.168.56.111"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}INSTALL_K3S_EXEC exported successfully${RESET}"
else
    echo -e "${RED}Failed to export INSTALL_K3S_EXEC${RESET}"
    exit 1
fi

# 4️⃣ Instalar K3s worker
if curl -sfL https://get.k3s.io | sh -; then
    echo -e "${GREEN}K3s worker installed successfully${RESET}"
else
    echo -e "${RED}K3s worker installation failed${RESET}"
    exit 1
fi

# 5️⃣ Esperar unos segundos a que se registre en el cluster
echo -e "${GREEN}Waiting for worker to register with master...${RESET}"
sleep 15

# 6️⃣ Verificar que el worker se unió al cluster
if sudo k3s kubectl get nodes | grep -q "worker"; then
    echo -e "${GREEN}K3s worker joined the cluster successfully${RESET}"
else
    echo -e "${RED}Worker did not join the cluster yet. Check master logs.${RESET}"
fi

# We delete the token for security, and also so that when restarting, a new token is used and not the previously created one

sudo rm /vagrant/token.env
