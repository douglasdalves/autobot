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

check_aws_cli() {
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
}


# ----------------------------------------------------------------------

# KUBECTL

# Obtém a versão estável mais recente disponível

check_kubectl() {
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
}



# ----------------------------------------------------------------------

# K9S

# Diretórios temporários

check_k9s() {
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
}

# ----------------------------------------------------------------------


check_k9s_gitbash() {
    echo "🔍 Detectando ambiente Git Bash no Windows..."

    ARCH=$(uname -m)
    case $ARCH in
        x86_64)   K9S_ARCH="amd64" ;;
        aarch64)  K9S_ARCH="arm64" ;;
        *)        echo "❌ Arquitetura $ARCH não suportada."; exit 1 ;;
    esac

    LATEST_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)

    INSTALL_DIR="/c/Users/douglas.alves/k9s"
    mkdir -p "$INSTALL_DIR"

    K9S_URL="https://github.com/derailed/k9s/releases/download/${LATEST_VERSION}/k9s_Windows_${K9S_ARCH}.zip"
    TEMP_FILE="/tmp/k9s.zip"

    echo "📥 Baixando k9s versão $LATEST_VERSION para Windows..."
    curl -L "$K9S_URL" -o "$TEMP_FILE" || { echo "❌ Falha no download"; exit 1; }

    echo "📦 Extraindo..."
    unzip -o "$TEMP_FILE" -d "$INSTALL_DIR" || { echo "❌ Falha ao extrair"; exit 1; }

    echo "✅ k9s instalado em $INSTALL_DIR"
    echo "➡️ Adicione $INSTALL_DIR ao PATH para usar o comando 'k9s'"
}

#echo 'export PATH=$PATH:/c/Users/'"$USERNAME"'/k9s' >> ~/.bashrc


# ----------------------------------------------------------------------

echo
echo "📋 Versão do script de instalação de pacotes WSL: 1.0.0"


list_parts() {
    echo "📦 Partes disponíveis:"
    grep -oP '^check_\K[^\(]+' "$0"
    echo
    echo "Exemplo: $0 aws_cli,kubectl,k9s"
    echo
}


# ----------------------------------------------------------------------
# Função principal para processar as opções
start_opcao() {
    local input="$1"

    if [ -z "$input" ]; then
        echo
        echo "⚠️ Nenhuma parte selecionada."
        echo 
        list_parts
        return
    fi

    echo "➡️ Partes solicitadas: $input"

    IFS=',' read -ra PARTS <<< "$input"

    for part in "${PARTS[@]}"; do
        case "${part,,}" in  # lower-case
            aws_cli)
                echo "🔍 Verificando AWS CLI..."
                check_aws_cli
                ;;
            kubectl)
                echo "🔍 Verificando kubectl..."
                check_kubectl
                ;;
            k9s)
                echo "🔍 Verificando k9s..."
                check_k9s
                ;;
            k9s_gitbash)
                echo "🔍 Verificando k9s..."
                check_k9s_gitbash
                ;;
            all)
                echo "🔍 Verificando todos os pacotes..."
                check_aws_cli
                check_kubectl
                check_k9s
                ;;
            *)
                echo "❌ Parte desconhecida: $part"
                ;;
        esac
    done
}

# Início do script
start_opcao "$1"

# ----------------------------------------------------------------------


