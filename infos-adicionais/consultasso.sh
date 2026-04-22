#!/bin/bash

echo -e "\n🔍 Listando os perfis:"

# Lista os perfis configurados no AWS CLI
if hostname | grep -q 'ACT9880'; then
    grep '\[' ~/.aws/config | sed -E 's/\[profile (.*)\]/\1/; s/\[(default)\]/\1/'
else
    aws configure list-profiles
fi

echo
read -p "✅ Digite o nome do perfil SSO da AWS: " PROFILE

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


function conectacao_sso {
    echo "📌 Gostaria de conectar ao SSO agora? (s/n)"
    read -r CONNECT
    if [[ "$CONNECT" =~ ^[sS]$ ]]; then
        echo "🔗 Conectando ao SSO..."
        aws sso login --profile "$PROFILE"
        if [ $? -eq 0 ]; then
            echo "✅ Conexão SSO bem-sucedida."
            # Executa o comando para verificar a identidade do usuário com o perfil SSO
            #echo "🔍 Executando 'aws sts get-caller-identity' com o perfil '$PROFILE'..."
            #aws sts get-caller-identity --profile "$PROFILE"
            if [ $? -ne 0 ]; then
                echo "❌ Falha ao executar 'aws sts get-caller-identity'. Verifique se o perfil SSO está configurado corretamente."
                exit 1
            fi
        else
            echo "❌ Falha ao conectar ao SSO. Verifique suas credenciais e tente novamente."
            exit 1 
        fi
    else
        echo "❌ Conexão SSO não realizada. Encerrando o script."
        exit 1
    fi
}



# Verifica se o diretório de cache SSO existe e se contém uma sessão ativa
echo "🔍 Verificando sessão SSO ativa em $CACHE_DIR..."

if [ -d "$CACHE_DIR" ] && grep -q '"startUrl"' "$CACHE_DIR"/*.json 2>/dev/null; then
    echo "✅ Sessão SSO ativa encontrada."
    conectacao_sso    
else
    echo "⚠️ Nenhuma sessão SSO ativa encontrada."
    conectacao_sso
fi
