#!/bin/bash

set -e

# Função para validar a entrada
validar_entrada() {
    local valor=$1
    sigla=$(echo $valor | cut -d'-' -f1)
    nome_do_repo=$(echo $valor | cut -d'-' -f2)

    if [[ ! "$sigla" =~ ^[A-Za-z]{4}$ ]]; then
        echo "❌ Erro: A sigla deve ter exatamente 4 letras."
        exit 1
    fi

    if [[ -z "$nome_do_repo" ]]; then
        echo "❌ Erro: O nome do repositório não pode estar vazio."
        exit 1
    fi
}

# Função para realizar a operação
realizar_operacao() {
    local comando="$1"
    echo -e "\n ✅ Realizando operação\n"
    # Verifica se a saída contém a mensagem esperada
    if echo "$resultado" | grep -qi "não localizado"; then
        echo "⚠️ Aviso: O serviço ou aplicação não foi localizado."
    elif [[ -z "$resultado" || "$resultado" == "null" ]]; then
        echo "⚠️ Aviso: O comando '$comando' não retornou dados."
    else
        echo "$resultado"
    fi
}


# Solicita o valor de entrada
echo
read -p "🔍 Insira Sigla-NomeDoRepo: " valor

# Valida a entrada
validar_entrada $valor

# Comandos
asre_service="asre catalogo servicos get $valor"
asre_apps="asre catalogo aplicacoes list | grep $sigla"

# Realiza as operações
realizar_operacao "$asre_service"
realizar_operacao "$asre_apps"

echo "✅ Operações concluídas com sucesso."