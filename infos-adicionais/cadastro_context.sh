#!/bin/bash

ARQUIVO="clusters.txt"
SKIP_SSL=true

# Perguntar ambiente
echo "Qual ambiente deseja configurar? (hml / uat / prd)"
read AMBIENTE

# Verificar se parâmetro --skip-ssl foi passado
for arg in "$@"; do
  if [[ "$arg" == "--skip-ssl" ]]; then
    SKIP_SSL=true
  fi
done

# Corrigir CRLF no arquivo clusters.txt
if [ -f "$ARQUIVO" ]; then
  sed -i 's/\r$//' "$ARQUIVO"
else
  echo "Arquivo $ARQUIVO não encontrado!"
  exit 1
fi

# Configurar variáveis SSL para Git Bash
CERT_PATH="/c/Program Files/Git/mingw64/ssl/certs/ca-bundle.crt"
if [ -f "$CERT_PATH" ]; then
  export SSL_CERT_FILE="$CERT_PATH"
  export REQUESTS_CA_BUNDLE="$CERT_PATH"
fi

# Limpar log de erros anterior
> erros.log

# Filtrar apenas clusters do ambiente escolhido
grep "$AMBIENTE" "$ARQUIVO" | while read -r ARN; do
  # Ignorar linhas vazias ou comentários
  if [[ -z "$ARN" || "$ARN" == \#* ]]; then
    continue
  fi

  REGIAO=$(echo "$ARN" | cut -d':' -f4)
  NOME=$(echo "$ARN" | awk -F'/' '{print $NF}')

  CMD="aws eks update-kubeconfig --region $REGIAO --name $NOME"
  if [ "$SKIP_SSL" == true ]; then
    CMD+=" --no-verify-ssl"
  fi

  # Executar comando, redirecionando erros para erros.log
  eval $CMD 2>>erros.log
  if [ $? -eq 0 ]; then
    CONTEXT=$(kubectl config get-contexts -o name | grep "$ARN")
    if [[ -n "$CONTEXT" ]]; then
      kubectl config rename-context "$CONTEXT" "$NOME" >/dev/null 2>&1
    fi
    echo "Contexto $NOME configurado com sucesso."
  fi
done

# Mostrar todos os contextos cadastrados no final
echo
echo "=== Contextos configurados atualmente ==="
kubectl config get-contexts
