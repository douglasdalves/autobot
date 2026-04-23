#!/bin/bash


# Para o script em caso de erro
set -e

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

check_py_install() {
    echo "🔎 Verificando winget..."
    if ! command -v winget >/dev/null 2>&1; then
        echo "❌ winget não encontrado."
        exit 1
    fi
    echo "✅ winget encontrado"

    TARGET_ID="Python.Python.3.12"

    echo
    echo "🔎 Verificando se $TARGET_ID está instalado..."

    if winget list --id "$TARGET_ID" --exact >/dev/null 2>&1; then
        echo "✅ Python 3.12 já instalado — verificando atualização..."
    else
        echo "ℹ️ Python 3.12 não encontrado — instalando..."
    fi

    echo
    echo "⬇️ Garantindo Python 3.12 (install/upgrade)..."
    winget install \
        --id "$TARGET_ID" \
        --source winget \
        --accept-source-agreements \
        --accept-package-agreements \
        --silent

    echo
    echo "🔧 Atualizando pip..."
    python -m ensurepip --upgrade || true
    python -m pip install --upgrade pip || true

    echo
    echo "📦 Instalando requirements.txt (se existir)..."
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    REQ_FILE="$SCRIPT_DIR/requirements.txt"

    if [ -f "$REQ_FILE" ]; then
        echo "➡️ Usando $REQ_FILE"
        python -m pip install --upgrade -r "$REQ_FILE"
    else
        echo "ℹ️ requirements.txt não encontrado — pulando etapa."
    fi

    echo
    echo "✅ Validação final:"
    python --version
    python3 --version || true

    echo
    echo "🎉 Python pronto e dependências aplicadas!"
}


# ----------------------------------------------------------------------

# Função para verificar se helm está instalado
helm_installed() {
    if command -v helm >/dev/null 2>&1; then
        echo "Helm já está instalado."
        return 0
    else
        echo "Helm não está instalado."
        return 1
    fi
}

# Função para verificar versão instalada vs última disponível no winget
helm_version() {
    local installed_version
    local latest_version

    installed_version=$(helm version --short 2>/dev/null | sed 's/v//')
    latest_version=$(winget show Helm.Helm | grep -i "Versão" | awk '{print $2}')

    echo "Versão instalada: $installed_version"
    echo "Última versão disponível: $latest_version"

    if [ "$installed_version" != "$latest_version" ]; then
        echo "Atualizando Helm para a versão mais recente..."
        winget install --id Helm.Helm --source winget --silent --accept-package-agreements --accept-source-agreements
    else
        echo "Helm já está na versão mais recente."
    fi
}

check_helm_usebash() {
    # Execução principal
    if helm_installed; then
        helm_version
    else
        echo "Instalando Helm..."
        winget install --id Helm.Helm --source winget --silent --accept-package-agreements --accept-source-agreements
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

check_kubectx_kubens_gitbash() {
    echo "🔍 Verificando kubectx e kubens no Git Bash..."

    ARCH=$(uname -m)
    case $ARCH in
        x86_64)   KUBECTX_ARCH="x86_64" ;;
        aarch64)  KUBECTX_ARCH="arm64" ;;
        *)        echo "❌ Arquitetura $ARCH não suportada."; exit 1 ;;
    esac

    LATEST_VERSION=$(curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | grep tag_name | cut -d '"' -f 4)

    INSTALL_DIR="/c/Users/douglas.alves/kubectx"
    mkdir -p "$INSTALL_DIR"

    KUBECTX_URL="https://github.com/ahmetb/kubectx/releases/download/${LATEST_VERSION}/kubectx_${LATEST_VERSION}_windows_${KUBECTX_ARCH}.zip"
    KUBENS_URL="https://github.com/ahmetb/kubectx/releases/download/${LATEST_VERSION}/kubens_${LATEST_VERSION}_windows_${KUBECTX_ARCH}.zip"
    TEMP_KUBECTX_FILE="/tmp/kubectx.zip"
    TEMP_KUBENS_FILE="/tmp/kubens.zip"

    echo "📥 Baixando kubectx versão $LATEST_VERSION para Windows..."
    curl -fL "$KUBECTX_URL" -o "$TEMP_KUBECTX_FILE" || { echo "❌ Falha no download do kubectx"; exit 1; }

    echo "📥 Baixando kubens versão $LATEST_VERSION para Windows..."
    curl -fL "$KUBENS_URL" -o "$TEMP_KUBENS_FILE" || { echo "❌ Falha no download do kubens"; exit 1; }

    echo "📦 Extraindo kubectx..."
    unzip -o "$TEMP_KUBECTX_FILE" -d "$INSTALL_DIR" || { echo "❌ Falha ao extrair kubectx"; exit 1; }

    echo "📦 Extraindo kubens..."
    unzip -o "$TEMP_KUBENS_FILE" -d "$INSTALL_DIR" || { echo "❌ Falha ao extrair kubens"; exit 1; }

    echo "✅ kubectx e kubens instalados em $INSTALL_DIR"
    echo "➡️ Adicione $INSTALL_DIR ao PATH para usar os comandos 'kubectx' e 'kubens'"
}

check_kubectl_gitbash() {
    echo "🔍 Verificando kubectl no Git Bash..."

    if ! command -v winget >/dev/null 2>&1; then
        echo "❌ winget não encontrado."
        exit 1
    fi

    TARGET_ID="Kubernetes.kubectl"

    if winget list --id "$TARGET_ID" --exact >/dev/null 2>&1; then
        echo "✅ kubectl já instalado — verificando atualização..."
    else
        echo "ℹ️ kubectl não encontrado — instalando..."
    fi

    echo "⬇️ Garantindo kubectl (install/upgrade)..."
    if winget install \
        --id "$TARGET_ID" \
        --source winget \
        --accept-source-agreements \
        --accept-package-agreements \
        --silent; then
        echo "✅ kubectl pronto para uso via winget!"
        return
    fi

    echo "⚠️ winget falhou ao baixar kubectl. Tentando fallback direto..."

    ARCH=$(uname -m)
    case $ARCH in
        x86_64)   KUBECTL_ARCH="amd64" ;;
        aarch64)  KUBECTL_ARCH="arm64" ;;
        *)        echo "❌ Arquitetura $ARCH não suportada."; exit 1 ;;
    esac

    LATEST_VERSION=$(curl -fLs https://dl.k8s.io/release/stable.txt || true)
    if [ -z "$LATEST_VERSION" ]; then
        echo "❌ Não foi possível obter a versão estável do kubectl."
        exit 1
    fi

    INSTALL_DIR="/c/Users/douglas.alves/kubectl"
    mkdir -p "$INSTALL_DIR"
    TARGET_FILE="$INSTALL_DIR/kubectl.exe"

    KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${LATEST_VERSION}/bin/windows/${KUBECTL_ARCH}/kubectl.exe"

    echo "📥 Baixando kubectl ${LATEST_VERSION} via storage.googleapis.com..."
    if ! curl -fL "$KUBECTL_URL" -o "$TARGET_FILE"; then
        echo "❌ Falha no download do kubectl."
        exit 1
    fi

    chmod +x "$TARGET_FILE" 2>/dev/null || true
    echo "✅ kubectl instalado em $TARGET_FILE"
    echo "➡️ Adicione $INSTALL_DIR ao PATH para usar o comando 'kubectl'"
}

#echo 'export PATH=$PATH:/c/Users/'"$USERNAME"'/k9s' >> ~/.bashrc

# ----------------------------------------------------------------------

check_aws_gitbash() {
    echo "🔍 Verificando AWS CLI no Git Bash..."

    if command -v aws >/dev/null 2>&1; then
        INSTALLED_VERSION=$(aws --version 2>&1 | awk '{print $1}' | cut -d/ -f2)
        echo "Versão instalada do AWS CLI: $INSTALLED_VERSION"
    else
        echo "AWS CLI não está instalado."
        INSTALLED_VERSION=""
    fi

    # Consultar última versão disponível no GitHub
    LATEST_VERSION=$(curl -s https://api.github.com/repos/aws/aws-cli/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//')

    echo "Última versão disponível: $LATEST_VERSION"

    if [ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]; then
        echo "📥 Instalando/Atualizando AWS CLI para versão $LATEST_VERSION..."

        ARCH=$(uname -m)
        case $ARCH in
            x86_64)   AWS_ARCH="x86_64" ;;
            aarch64)  AWS_ARCH="arm64" ;;
            *)        echo "❌ Arquitetura $ARCH não suportada."; exit 1 ;;
        esac

        INSTALL_DIR="/c/Users/douglas.alves/awscli"
        mkdir -p "$INSTALL_DIR"

        AWS_URL="https://awscli.amazonaws.com/AWSCLIV2.msi"
        TEMP_FILE="/tmp/awscliv2.msi"

        curl -L "$AWS_URL" -o "$TEMP_FILE" || { echo "❌ Falha no download"; exit 1; }

        echo "📦 Instalando AWS CLI..."
        msiexec //i "$TEMP_FILE" //qn || { echo "❌ Falha na instalação"; exit 1; }

        echo "✅ AWS CLI instalado/atualizado em $INSTALL_DIR"
    else
        echo "AWS CLI já está na versão mais recente."
    fi

    echo "🔒 Validando uso de SSL..."
    aws configure set cli_follow_urlparam false
    aws configure set ca_bundle /c/Windows/System32/drivers/etc/ssl/certs/ca-bundle.crt
    echo "✅ SSL ativado para AWS CLI"
}

# ----------------------------------------------------------------------


# ----------------------------------------------------------------------

echo
echo "📋 Versão do script de instalação de pacotes Use Bash: 1.0.4"


list_parts() {
    echo "📦 Partes disponíveis:"
    awk '
        /^[[:space:]]*check_[a-zA-Z0-9_]+[[:space:]]*\(\)[[:space:]]*\{/ {
            name=$1
            gsub(/check_|\(\).*/, "", name)
            print " - " name
        }
    ' "$0"
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
            helm_usebash)
                echo "🔄 Atualizando helm..."
                check_helm_usebash
                ;;
            k9s_gitbash)
                echo "🔄 Atualizando k9s..."
                check_k9s_gitbash
                ;;
            kubectx_kubens_gitbash|kubectx_gitbash|kubens_gitbash)
                echo "🔄 Instalando/atualizando kubectx e kubens..."
                check_kubectx_kubens_gitbash
                ;;
            kubectl_gitbash)
                echo "🔄 Instalando/atualizando kubectl..."
                check_kubectl_gitbash
                ;;
            py_install)
                echo "🔄 Verificando/instalando Python..."
                check_py_install
                ;;
            all)
                echo "🔄 Executando todas as partes..."
                check_helm_usebash
                check_k9s_gitbash
                check_kubectx_kubens_gitbash
                check_kubectl_gitbash
                ;;
            *)
                echo "❌ Parte desconhecida: $part"
                ;;
        esac
    done
}

# Início do script
start_opcao "$1"