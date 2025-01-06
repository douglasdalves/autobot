

#!/bin/bash

# Solicitar o host ao usuário
echo
read -p "Digite o host:porta:" host
echo

# Extrair o nome do host sem a porta
host_name=$(echo $host | cut -d':' -f1)

# Definir o tempo limite em segundos
timeout_seconds=10

# Construir e executar o comando com timeout para o telnet
echo "Conectando a curl -vvv telnet://$host por $timeout_seconds segundos..."
timeout $timeout_seconds curl -vvv telnet://$host

# Verificar o status do comando
if [ $? -eq 124 ]; then
    echo 
    echo "Conexão encerrada automaticamente após $timeout_seconds segundos."
    echo
else
    echo 
    echo "Falha na resolução do curl/telnet."
    echo
fi

# Testar resolução de DNS usando nslookup
echo
echo "Verificando a resolução DNS para o host $host_name..."
nslookup $host_name

# Verificar o status do comando nslookup
if [ $? -eq 0 ]; then
    echo "Resolução DNS bem-sucedida."
    echo
else
    echo "Falha na resolução DNS para o host $host_name."
    echo
fi
