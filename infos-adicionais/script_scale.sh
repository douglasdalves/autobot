#!/bin/bash

# Uso: ./scale_to_zero.sh <namespace> <replicas>
# Exemplo: ./scale_to_zero.sh default 0

NAMESPACE=$1
REPLICAS=$2
APP_LIST="apps.txt"

# Verifica se os parâmetros foram passados
if [[ -z "$NAMESPACE" || -z "$REPLICAS" ]]; then
    echo "Uso: $0 <namespace> <replicas>"
    exit 1
fi

# Verifica se o arquivo existe
if [[ ! -f "$APP_LIST" ]]; then
    echo "Arquivo $APP_LIST não encontrado!"
    exit 1
fi

# Loop pelas aplicações
while read -r app; do
    if [[ -n "$app" ]]; then
        echo "Escalando $app para $REPLICAS réplicas no namespace $NAMESPACE..."
        kubectl scale deployment "$app" --replicas="$REPLICAS" -n "$NAMESPACE"
    fi
done < "$APP_LIST"

echo "Processo concluído!"