#!/bin/bash

# Para o script em caso de erro
set -e

# Função para verificar se o Helm está instalado
function check_helm_installed {
    if ! command -v helm &> /dev/null; then
        echo "Helm não está instalado. Por favor, instale o Helm para continuar."
        exit 1
    else
        echo "Helm está instalado."
        echo
        helm version
        echo
    fi
}


# Executando as verificações e instalação
check_helm_installed