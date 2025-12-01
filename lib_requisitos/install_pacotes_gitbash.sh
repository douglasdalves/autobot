#!/bin/bash


# Para o script em caso de erro
set -e

# ----------------------------------------------------------------------
# ----------------------------------------------------------------------

#!/bin/bash

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

echo
echo "📋 Versão do script de instalação de pacotes Use Bash: 1.0.0"


list_parts() {
    echo "📦 Partes disponíveis:"
    grep '^check_' "$0" | sed 's/(.*//'
    echo
    echo "Exemplo: $0 consulta_helm_usebash"
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
            check_helm_usebash)
                echo "🔄 Atualizando helm..."
                check_helm_usebash
                ;;
            all)
                echo "🔄 Executando todas as partes..."
                check_helm_usebash
                ;;
            *)
                echo "❌ Parte desconhecida: $part"
                ;;
        esac
    done
}

# Início do script
start_opcao "$1"