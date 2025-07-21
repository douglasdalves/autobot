#!/bin/bash

# ------------------------------------------
# Instalação de Requisitos para WSL2
# ------------------------------------------

# CLI - KUBECTL - K9S #

# Para o script em caso de erro
set -e

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

#!/bin/bash

# Função para verificar se a versão instalada é a v2
is_aws_cli_v2() {
    aws --version 2>/dev/null | grep -q 'aws-cli/2'
}

# Verifica se o AWS CLI está instalado
if command -v aws &> /dev/null; then
    echo
    echo "Versão atual do AWS CLI:"
    aws --version
    echo

    if is_aws_cli_v2; then
        echo "✅ AWS CLI já está na versão 2. Nenhuma ação necessária."
    else
        echo "⚠️ AWS CLI está instalado, mas não é a versão 2. Atualizando..."
        
        # Instalação da versão 2
        sudo apt update
        sudo apt install unzip -y
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip -o awscliv2.zip
        sudo ./aws/install --update
        rm -rf awscliv2.zip aws

        echo
        echo "✅ AWS CLI atualizado com sucesso para:"
        aws --version
    fi
else
    echo "❌ AWS CLI não está instalado. Instalando agora..."

    sudo apt update
    sudo apt install unzip -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws

    echo
    echo "✅ AWS CLI instalado com sucesso:"
    aws --version
fi


# ----------------------------------------------------------------------

# Verifica se o kubectl está instalado
if ! command -v kubectl &> /dev/null
then
    echo "kubectl não está instalado. Instalando agora..."

    # Baixa a versão mais recente do kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    # Concede permissão de execução
    chmod +x kubectl

    # Move o kubectl para o diretório /usr/local/bin para que ele seja acessível globalmente
    sudo mv kubectl /usr/local/bin/

    # Confirma a instalação
    if command -v kubectl &> /dev/null
    then
        echo "kubectl foi instalado com sucesso!"
    else
        echo "Houve um erro ao instalar o kubectl."
    fi
else
    echo
    echo "kubectl já está instalado."
    echo
    kubectl version --client --output=yaml
fi

# ----------------------------------------------------------------------


# Verifica se o k9s já está instalado
if command -v k9s &> /dev/null
then
    echo "O k9s já está instalado na máquina."
    exit 0
fi

# Define variáveis
K9S_VERSION="v0.32.5"
K9S_URL="https://github.com/derailed/k9s/releases/download/$K9S_VERSION/k9s_Linux_x86_64.tar.gz"
TEMP_FILE="/tmp/k9s.tar.gz"
TEMP_DIR="/tmp"

# Faz o download do k9s
echo "Baixando o k9s versão $K9S_VERSION..."
wget "$K9S_URL" -O "$TEMP_FILE"
if [ $? -ne 0 ]; then
    echo "Falha ao baixar o k9s. Verifique sua conexão e o link."
    exit 1
fi

# Extrai o arquivo
echo "Extraindo o arquivo..."
tar -zxvf "$TEMP_FILE" --directory "$TEMP_DIR"
if [ $? -ne 0 ]; then
    echo "Falha ao extrair o arquivo."
    exit 1
fi

# Define permissões e move o binário
echo "Instalando o k9s..."
chmod +x "$TEMP_DIR/k9s"
sudo mv "$TEMP_DIR/k9s" /usr/local/bin/k9s
if [ $? -ne 0 ]; then
    echo "Falha ao mover o k9s para /usr/local/bin. Verifique permissões."
    exit 1
fi

# Limpa o arquivo temporário
rm -f "$TEMP_FILE"

# Verifica a instalação
if command -v k9s &> /dev/null
then
    echo "k9s instalado com sucesso!"
    k9s version
else
    echo "Falha na instalação do k9s."
    exit 1
fi


# ----------------------------------------------------------------------

echo
echo "Instalação e listagem completa!"
echo



