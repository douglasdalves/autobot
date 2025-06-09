#!/bin/bash

read -p "Informe a região AWS (ex: us-east-1): " REGION

echo -e "\n🔍 Verificando clusters EKS na região $REGION..."
aws eks list-clusters --region "$REGION" --output json | jq -r '.clusters[]?'

echo -e "\n🔍 Verificando clusters MSK padrão na região $REGION..."
aws kafka list-clusters --region "$REGION" --output json | jq -r '.ClusterInfoList[]?.ClusterName'

echo -e "\n🔍 Verificando clusters MSK Serverless na região $REGION..."
aws kafka list-clusters-v2 --region "$REGION" --output json | jq -r '.ClusterInfoList[]?.ClusterName'