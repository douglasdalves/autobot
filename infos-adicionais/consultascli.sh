#!/bin/bash

set -e

# Função para validar a entrada
validar_entrada() {
    local valor=$1
    sigla=$(echo $valor | cut -d'-' -f1)
    nome_do_repo=$(echo $valor | cut -d'-' -f2)

    if [[ ! "$sigla" =~ ^[A-Za-z]{4}$ ]]; then
        echo "Erro: A sigla deve ter exatamente 4 letras."
        exit 1
    fi

    if [[ -z "$nome_do_repo" ]]; then
        echo "Erro: O nome do repositório não pode estar vazio."
        exit 1
    fi
}

# Função para realizar a operação
realizar_operacao() {
    local comando=$1
    echo
    echo "--- Realizando operação ---"
    echo
    resultado=$(eval $comando)
    if [[ $? -ne 0 ]]; then
        echo "Erro ao executar '$comando'"
        exit 1
    fi
    echo "$resultado"
    echo
}

# Solicita o valor de entrada
echo "Insira a Sigla-NomeDoRepo:"
echo
read valor

# Valida a entrada
validar_entrada $valor

# Comandos
asre_service="asre catalogo servicos get $valor"
asre_apps="asre catalogo aplicacoes get $sigla"

# Realiza as operações
realizar_operacao "$asre_service"
realizar_operacao "$asre_apps"

echo "Operações concluídas com sucesso."
