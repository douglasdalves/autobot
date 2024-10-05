#!/bin/bash

# ------------------------------------------
# Instalação de pacotes para o Python
# ------------------------------------------

# Para o script em caso de erro
set -e

# Atualizando os pacotes do sistema
echo "Atualizando pacotes do sistema..."
sudo apt-get update && sudo apt-get upgrade -y

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

# Verifica se o AWS CLI está instalado
if command -v aws &> /dev/null; then
    echo "Versão do AWS CLI:"
    aws --version
else
    echo "AWS CLI não está instalado. Instalando agora..."

    # Instalação do AWS CLI
    echo "Instalando unzip..."
    sudo apt install unzip -y

    echo "Baixando o AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

    echo "Descompactando o instalador..."
    unzip awscliv2.zip

    echo "Instalando o AWS CLI..."
    sudo ./aws/install

    echo "Removendo arquivos temporários..."
    rm -rf awscliv2.zip aws

    echo "AWS CLI instalado com sucesso."
    echo "Versão do AWS CLI:"
    aws --version
fi

echo
echo "Instalação e listagem completa!"
echo



