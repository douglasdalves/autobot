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

#echo 'export PATH=$PATH:/c/Users/'"$USERNAME"'/k9s' >> ~/.bashrc

# ----------------------------------------------------------------------

echo
echo "📋 Versão do script de instalação de pacotes Use Bash: 1.0.2"


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
            py_install)
                echo "🔄 Verificando/instalando Python..."
                check_py_install
                ;;
            all)
                echo "🔄 Executando todas as partes..."
                check_helm_usebash
                check_k9s_gitbash
                ;;
            *)
                echo "❌ Parte desconhecida: $part"
                ;;
        esac
    done
}

# Início do script
start_opcao "$1"