#!/bin/bash

set -e  # Para o script em caso de erro

# Script para instalar pacotes no Linux (Debian/Ubuntu)

# ----------------------------------------------------------------------
# Atualizando pacotes do sistema

check_upgrade() {
    echo
    echo "✅ Atualizando pacotes do sistema..."
    sudo apt-get update -y
    sudo apt-get upgrade -y
    echo "✅ Pacotes do sistema atualizados com sucesso."
    echo
}

# ----------------------------------------------------------------------
# Verificando instalação do pip3

check_python3() {
    if ! command -v pip3 &> /dev/null; then
        echo "📦 Instalando o Python3-pip..."
        sudo apt-get install python3-pip -y
    else
        echo "✅ pip3 já está instalado. Versão: $(pip3 --version)"
        pip3 install --upgrade pip --root-user-action=ignore
    fi


# ----------------------------------------------------------------------
# Verifica se o arquivo requirements.txt existe

    if [ ! -f requirements.txt ]; then
        echo "❌ Arquivo requirements.txt não encontrado!"
        exit 1
    fi

    # Instalar pacotes do arquivo requirements.txt
    echo "📦 Instalando pacotes do requirements.txt..."
    pip3 install -r requirements.txt --root-user-action=ignore --quiet || {
        echo "❌ Erro ao instalar pacotes do requirements.txt"
        exit 1
    }
    echo "✅ Pacotes Python instalados com sucesso."

    # Listar pacotes instalados
    echo "📋 Pacotes instalados do requirements.txt:"
    pip list --format=freeze | grep -f requirements.txt || echo "Nenhum pacote correspondente encontrado."
    echo
}

# ----------------------------------------------------------------------
# Instalação do Node.js (última versão LTS)

check_nodejs_brew() {
    if ! command -v node &> /dev/null; then
        echo "📦 Instalando Node.js (última LTS)..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    else
        echo "✅ Node.js já está instalado. Versão: $(node -v)"
        echo "🔄 Atualizando Node.js para última LTS..."
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
    echo "✅ NPM versão: $(npm -v)"

# ----------------------------------------------------------------------
# Instalação do Homebrew (Linuxbrew)
    BREW_USER=usobrew

    USERNAME=$BREW_USER

    if [ -z "$BREW_USER" ]; then
        echo "❌ Variável de ambiente BREW_USER não definida!"
        echo "   Exemplo: BREW_USER=meuusuario ./install.sh"
        exit 1
    fi

    if id "$USERNAME" &>/dev/null; then
        echo "Usuário '$USERNAME' já existe."
    else
        echo "Criando usuário '$USERNAME'..."
        useradd -m -s /bin/bash "$USERNAME"
        echo "$USERNAME:marcia" | chpasswd
        echo "Usuário criado com sucesso."
    fi
    

    # instalação do Homebrew
    if ! command -v brew &> /dev/null; then
        echo "📦 Instalando Homebrew para o usuário $BREW_USER ..."
        sudo -u "$BREW_USER" bash -c 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

        # Adicionar ao .bashrc do usuário
        sudo -u "$BREW_USER" bash -c 'echo "eval \"$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> ~/.bashrc'
        sudo -u "$BREW_USER" bash -c 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
    else
        echo "✅ Homebrew já está instalado. Versão: $(brew --version)"
        echo "🔄 Atualizando Homebrew..."
        sudo -u "$BREW_USER" brew update
    fi
    echo "✅ Homebrew instalado/atualizado com sucesso."
}
# ----------------------------------------------------------------------

# Instalação do Gemini CLI

check_gemini_cli() {
    if ! command -v gemini &> /dev/null; then
        echo "📦 Instalando Gemini CLI..."
        npx https://github.com/google-gemini/gemini-cli
        npm install -g @google/gemini-cli
        echo "✅ Gemini CLI versão: $(gemini --version)"
    else
        echo "✅ Gemini CLI já está instalado. Versão: $(gemini --version)"
        echo "🔄 Atualizando Gemini CLI..."
        npm update -g @google/gemini-cli
    fi
    echo "✅ Gemini CLI instalado/atualizado com sucesso."
}



# ----------------------------------------------------------------------

echo
echo "📋 Versão do script de instalação de pacotes Linux: 1.0.0"


list_parts() {
    echo "📦 Partes disponíveis:"
    grep -oP '^check_\K[^\(]+' "$0"
    echo
    echo "Exemplo: $0 python,nodejs"
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
            upgrade)
                echo "🔄 Atualizando pacotes do sistema..."
                check_upgrade
                ;;
            python3)
                echo "📦 Instalando Python..."
                check_python3
                ;;
            nodejs_brew)
                echo "📦 Instalando Node.js..."
                check_nodejs_brew
                ;;
            gemini_cli)
                echo "📦 Instalando Gemini CLI..."
                check_gemini_cli
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

