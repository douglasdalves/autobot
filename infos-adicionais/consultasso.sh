#!/bin/bash

echo -e "\n🔍 Listando os perfis:"

# Lista os perfis configurados no AWS CLI
aws configure list-profiles

echo
read -p "Digite o nome do perfil SSO da AWS: " PROFILE

# Verifica se o perfil SSO existe e se a sessão SSO está ativa
CONFIG_FILE="$HOME/.aws/config"
CACHE_DIR="$HOME/.aws/sso/cache"

echo "🔍 Verificando se o perfil '$PROFILE' existe em $CONFIG_FILE..."

if grep -q "\[profile $PROFILE\]" "$CONFIG_FILE"; then
    echo "✅ Perfil encontrado."
else
    echo "❌ Perfil '$PROFILE' não encontrado em $CONFIG_FILE."
    exit 1
fi

# Verifica se o diretório de cache SSO existe e se contém uma sessão ativa
echo "🔍 Verificando sessão SSO ativa em $CACHE_DIR..."

if [ -d "$CACHE_DIR" ] && grep -q '"startUrl"' "$CACHE_DIR"/*.json 2>/dev/null; then
    echo "✅ Sessão SSO ativa encontrada."
else
    echo "⚠️ Nenhuma sessão SSO ativa encontrada. Execute: aws sso login --profile $PROFILE"
fi

# Executa o comando para verificar a identidade do usuário com o perfil SSO
echo "🔍 Executando 'aws sts get-caller-identity' com o perfil '$PROFILE'..."
aws sts get-caller-identity --profile "$PROFILE"
if [ $? -ne 0 ]; then
    echo "❌ Falha ao executar 'aws sts get-caller-identity'. Verifique se o perfil SSO está configurado corretamente."
    exit 1
fi