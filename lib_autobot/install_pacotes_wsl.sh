#!/bin/bash

# ------------------------------------------
# Instalação de Requisitos para WSL2
# ------------------------------------------

# CLI - KUBECTL - K9S #

# Para o script em caso de erro
set -e

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

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

# KUBECTL

# Obtém a versão estável mais recente disponível
LATEST_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

# Função para instalar ou atualizar kubectl
install_kubectl() {
    echo "📥 Baixando kubectl versão $LATEST_VERSION ..."
    curl -LO "https://dl.k8s.io/release/${LATEST_VERSION}/bin/linux/amd64/kubectl"

    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    echo "✅ kubectl versão $LATEST_VERSION instalado/atualizado!"
}

# Verifica se o kubectl está instalado
if ! command -v kubectl &> /dev/null; then
    echo "kubectl não está instalado. Instalando agora..."
    install_kubectl
else
    echo "✅ kubectl já está instalado."
    INSTALLED_VERSION=$(kubectl version --client -o yaml | grep gitVersion: | awk '{print $2}')

    echo "Versão instalada: $INSTALLED_VERSION"
    echo "Versão mais recente: $LATEST_VERSION"

    if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
        echo "🔄 Atualizando kubectl para a versão mais recente..."
        install_kubectl
    else
        echo "👍 kubectl já está na versão mais recente."
    fi
fi



# ----------------------------------------------------------------------

# K9S

# Diretórios temporários
TEMP_FILE="/tmp/k9s.tar.gz"
TEMP_DIR="/tmp"

# Detecta arquitetura
ARCH=$(uname -m)
case $ARCH in
    x86_64)   K9S_ARCH="amd64" ;;
    aarch64)  K9S_ARCH="arm64" ;;
    *)        echo "❌ Arquitetura $ARCH não suportada."; exit 1 ;;
esac

# Obtém a versão mais recente do GitHub
LATEST_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)

install_k9s() {
    echo "📥 Baixando k9s versão $LATEST_VERSION para $K9S_ARCH ..."
    K9S_URL="https://github.com/derailed/k9s/releases/download/${LATEST_VERSION}/k9s_Linux_${K9S_ARCH}.tar.gz"
    wget -q "$K9S_URL" -O "$TEMP_FILE" || { echo "❌ Falha no download ($K9S_URL)"; exit 1; }

    echo "📦 Extraindo..."
    tar -zxf "$TEMP_FILE" --directory "$TEMP_DIR" || { echo "❌ Falha ao extrair"; exit 1; }

    echo "⚙️ Instalando..."
    chmod +x "$TEMP_DIR/k9s"
    sudo mv "$TEMP_DIR/k9s" /usr/local/bin/k9s
    rm -f "$TEMP_FILE"

    echo "✅ k9s versão $LATEST_VERSION instalado/atualizado!"
    k9s version | grep "Version:"
}

if command -v k9s &> /dev/null; then
    echo "🔍 k9s já está instalado."
    INSTALLED_VERSION=$(k9s version | grep "Version:" | awk '{print $2}')

    echo "Versão instalada: $INSTALLED_VERSION"
    echo "Versão mais recente: $LATEST_VERSION"

    if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
        echo "🔄 Atualizando k9s..."
        install_k9s
    else
        echo "👍 k9s já está na versão mais recente."
    fi
else
    echo "⚠️ k9s não está instalado. Instalando agora..."
    install_k9s
fi





# ----------------------------------------------------------------------

echo
echo "✅ Instalação e listagem completa!"
echo



