#!/bin/bash

set -e

# Solicita o nome do repositório
read -p "✅ Digite repositorio: " repo_name
echo

# Verifica se o nome do repositório está vazio
if [ -z "$repo_name" ]; then
  echo "❌ Erro: O nome do repositório não pode ficar em branco."
  exit 1
fi

# Executa os comandos com o nome do repositório inserido
echo -e "\n-- Infos no EKS --\n"
kubectl get all -A | grep "$repo_name"

# Exibe o campo image de todos os pods que correspondem ao repo_name
echo -e "\n-- List ID Image --\n"
kubectl get pods -A -o jsonpath="{range .items[*]}{.metadata.name}{'\t'}{.spec.containers[*].image}{'\n'}{end}" | grep "$repo_name"

# Lista a versao aplicada via release helm
echo -e "\n-- Releases List --\n"
helm list -A | grep "$repo_name"

echo -e "\n-- Releases Removida com histórico --\n"
# Procura alguma release removida com o registro
helm list --uninstalled -A | grep "$repo_name"
echo