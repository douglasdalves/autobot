#!/bin/bash

# ------------------------------------------
# Instalação de Requisitos Python
# ------------------------------------------

# Para o script em caso de erro
set -e

# Atualizando os pacotes do sistema
echo "Atualizando pacotes do sistema..."
sudo apt-get update
sudo apt-get upgrade -y

# Verificando se o pip já está instalado
if ! command -v pip3 &> /dev/null; then
    echo "Instalando o Python3-pip..."
    echo
    sudo apt-get install python3-pip -y
else
    echo
    echo "pip3 já está instalado."
    #pip3 install --upgrade pip --root-user-action=ignore
fi

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

# Verifica se o arquivo requirements.txt existe
if [ ! -f requirements.txt ]; then
    echo "Arquivo requirements.txt não encontrado!"
    exit 1
fi

# Instalar pacotes do arquivo requirements.txt
echo
echo "Instalando pacotes do arquivo requirements.txt..."
pip3 install -r requirements.txt --root-user-action=ignore --quiet || {
    echo "Erro ao instalar pacotes do requirements.txt"
    exit 1
}

echo
echo "Pacotes instalados com sucesso."

# Listar apenas os pacotes instalados a partir do requirements.txt
echo "Listando pacotes instalados a partir do requirements.txt:"
pip list --format=freeze | grep -f requirements.txt
echo

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

echo
echo "Instalação e listagem completa!"
echo



