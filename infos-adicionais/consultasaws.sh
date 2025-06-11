#!/bin/bash

echo -e "\n Consultas na AWS"
echo -e "Escolha uma região da lista abaixo:\n"

# Lista de regiões disponíveis
REGIONS=("ohio - us-east-2" "virginia - us-east-1" "sao paulo - sa-east-1" "Cancelar")

# Menu de seleção
select opt in "${REGIONS[@]}"; do
    case $REPLY in
        1) REGION="us-east-2"; break ;;
        2) REGION="us-east-1"; break ;;
        3) REGION="sa-east-1"; break ;;
        4) echo "Operação cancelada."; exit ;;
        *) echo "Opção inválida. Tente novamente." ;;
    esac
done

echo -e "\n🔍 Verificando clusters EKS na região $REGION..."
aws eks list-clusters --region "$REGION" --output json | jq -r '.clusters[]?'

echo -e "\n🔍 Verificando clusters MSK padrão na região $REGION..."
aws kafka list-clusters --region "$REGION" --output json | jq -r '.ClusterInfoList[]?.ClusterName'

echo -e "\n🔍 Verificando clusters MSK Serverless na região $REGION..."
aws kafka list-clusters-v2 --region "$REGION" --output json | jq -r '.ClusterInfoList[]?.ClusterName'

echo -e "\n🔍 Verificando brokers do Amazon MQ na região $REGION..."
aws mq list-brokers --region "$REGION" --output json | jq -r '.BrokerSummaries[]?.BrokerName'

echo
read -p "Informe a sigla para filtrar os secrets: " SIGLA

echo -e "\n🔍 Buscando secrets que contenham '$SIGLA' na região $REGION..."
aws secretsmanager list-secrets --region "$REGION" --output json | \
jq -r --arg sigla "$SIGLA" '.SecretList[]? | select(.Name | test($sigla; "i")) | .Name'

