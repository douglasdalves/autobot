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

# -------------------------------------------------------------#

# Listando clusters EKS na região selecionada
echo -e "\n🔍 Verificando clusters EKS na região $REGION..."
aws eks list-clusters --region "$REGION" --output json | jq -r '.clusters[]?'

# Listando clusters MSK na região selecionada
echo -e "\n🔍 Verificando clusters MSK Serverless na região $REGION..."
aws kafka list-clusters-v2 --region "$REGION" --output json | jq -r '.ClusterInfoList[]?.ClusterName'

# Listando brokers do Amazon MQ na região selecionada
echo -e "\n🔍 Verificando brokers do Amazon MQ na região $REGION..."
aws mq list-brokers --region "$REGION" --output json | jq -r '.BrokerSummaries[]?.BrokerName'


# -------------------------------------------------------------#
echo
read -p "Informe a sigla para filtrar os secrets: " SIGLA

# Verificando se a sigla foi informada
echo -e "\n🔍 Buscando secrets que contenham '$SIGLA' na região $REGION..."

if [ -z "$SIGLA" ]; then
    echo "Nenhuma sigla informada. Listando todos os secrets."
    SIGLA=".*"  # Regex que corresponde a qualquer string
fi
# Listando secrets no Secrets Manager filtrados pela sigla
aws secretsmanager list-secrets --region "$REGION" --output json | \
jq -r --arg sigla "$SIGLA" '.SecretList[]? | select(.Name | test($sigla; "i")) | .Name'

# -------------------------------------------------------------#

echo
read -p "Informe o namespace para consultar as ServiceAccounts: " NAMESPACE

echo -e "\n🔍 Listando ServiceAccounts no namespace '$NAMESPACE'..."
if [ -z "$NAMESPACE" ]; then
    echo "Nenhum namespace informado. Usando o namespace padrão 'default'."
    NAMESPACE="default"
fi

# Listando ServiceAccounts no namespace informado
if [ $? -ne 0 ]; then
    echo "Erro ao listar ServiceAccounts. Verifique se o namespace '$NAMESPACE' existe."
else
    echo -e "\n🔍 Verificando ServiceAccounts com secrets no namespace '$NAMESPACE'..."
    kubectl get serviceaccounts -n "$NAMESPACE"
fi

# Listando ServiceAccounts com role-arn, se houver
echo -e "\n🔍 Listando ServiceAccounts no namespace '$NAMESPACE' com role-arn (se houver)..."
kubectl get serviceaccounts -n "$NAMESPACE" -o json | jq -r '
  .items[] | 
  {
    name: .metadata.name,
    roleArn: (.metadata.annotations."eks.amazonaws.com/role-arn" // "N/A")
  } | 
  "🔹 SA: \(.name)\n   ↳ Role ARN: \(.roleArn)\n"
'
