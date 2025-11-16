#!/bin/bash

echo "🔍 Verificando instalação do AWS CLI..."

AWS_PATH=$(which aws 2>/dev/null)

if [ -z "$AWS_PATH" ]; then
    echo "✅ AWS CLI não está instalado."
    exit 0
else
    echo "📍 AWS CLI encontrado em: $AWS_PATH"
fi

# Função para remover via apt
remove_via_apt() {
    echo "🧹 Removendo AWS CLI via apt..."
    sudo apt remove -y awscli
    sudo apt purge -y awscli
    sudo apt autoremove -y
}

# Função para remover via pip
remove_via_pip() {
    echo "🧹 Removendo AWS CLI via pip..."
    pip uninstall -y awscli || pip3 uninstall -y awscli
}

# Função para remover instalação manual
remove_manual_install() {
    echo "🧹 Removendo AWS CLI instalado manualmente..."
    sudo /usr/local/aws-cli/v2/current/uninstall 2>/dev/null
    sudo rm -rf /usr/local/aws-cli
    sudo rm -f /usr/local/bin/aws
}

# Detectar método de instalação
if [[ "$AWS_PATH" == "/usr/bin/aws" ]]; then
    remove_via_apt
elif [[ "$AWS_PATH" == *".local/bin/aws" ]]; then
    remove_via_pip
elif [[ "$AWS_PATH" == "/usr/local/bin/aws" ]]; then
    remove_manual_install
else
    echo "⚠️ Método de instalação não identificado. Tentando todas as opções..."
    remove_via_apt
    remove_via_pip
    remove_manual_install
fi

# Verificação final
if ! command -v aws &> /dev/null; then
    echo "✅ AWS CLI removido com sucesso."
else
    echo "❌ Falha ao remover o AWS CLI. Verifique manualmente."
fi
