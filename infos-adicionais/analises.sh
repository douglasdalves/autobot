
#!/bin/bash

# Solicitar o host ao usuário
echo
read -p "Digite o host:porta): telnet://" host
echo

# Definir o tempo limite em segundos
timeout_seconds=10

# Construir e executar o comando com timeout
echo "Conectando a curl -vvv telnet://$host por $timeout_seconds segundos..."
timeout $timeout_seconds curl -vvv telnet://$host


# Verificar o status do comando
if [ $? -eq 124 ]; then
    echo 
    echo "Conexão encerrada automaticamente após $timeout_seconds segundos."
    echo
else
    echo 
    echo "Comando encerrado."
    echo
fi

