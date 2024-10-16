#!/usr/bin/env python3

# ------------------------------------------
# import
# ------------------------------------------

import subprocess
import os
from termcolor import colored


# ------------------------------------------
# Format colored
# ------------------------------------------

def cabecalho_sub(texto):
    print(colored(f"--- {texto} ---", 'green', attrs=['bold']))

def cabecalho_cor(texto):
    print(colored(f"{texto}", 'red', attrs=['bold']))

def cabecalho_menu(texto):
    print(colored(f"\n---- AUTOBOT ----", 'green', attrs=['reverse', 'bold']), end='') 
    print(colored(f" {texto}", 'green', attrs=['reverse']))


# ------------------------------------------
# libs
# ------------------------------------------

from lib_autobot.docker_comandos import fun_start_docker
from lib_autobot.docker_comandos import fun_stop_docker

# ------------------------------------------
# libs - func
# ------------------------------------------

def executar_comando(comando, shell=False):
    try:
        resultado = subprocess.run(comando, shell=shell, check=True, text=True, capture_output=True)
        print(resultado.stdout)
    except subprocess.CalledProcessError as e:
        print(colored(f"Erro ao executar o comando: {comando}\nErro: {e.stderr}", 'red'))
    except Exception as e:
        print(colored(f"Ocorreu um erro inesperado: {e}", 'red'))


def comando_vscode():
    caminho = "/root/devops/automation-py/autobot"
            
            # Verifica se o caminho existe
    if os.path.exists(caminho):
                # Altera o diretório para o caminho especificado
        os.chdir(caminho)
                
                # Abre o VS Code no diretório atual
        executar_comando(['code', '.'])
    else:
        print(f"O caminho {caminho} não existe.")


# ------------------------------------------
# ------------------------------------------

def dev_docker():
    cabecalho_sub('Funções em Docker')
    executar_comando(['docker', 'ps', '-a'])
    print('\n')
    cabecalho_sub('Listando Imagens Docker')
    executar_comando(['docker', 'images'])
    print('\n')

# ------------------------------------------
# ------------------------------------------

def listar_credenciais():
    cabecalho_sub('Listando credenciais AWS (PARCIAL)')
    try:
        with open(os.path.expanduser("~/.aws/credentials"), 'r') as f:
            for line in f:
                if line.startswith("["):
                    print(colored(line.strip(), 'yellow'))  # Mostra apenas o nome dos perfis
    except FileNotFoundError:
        print(colored('Arquivo de credenciais não encontrado.', 'red'))

def listar_configuracoes():
    cabecalho_sub('Listando configurações AWS')
    executar_comando(['cat', os.path.expanduser("~/.aws/config")], shell=True)

def listar_perfis():
    cabecalho_sub('Listando perfis configurados')
    executar_comando(['aws', 'configure', 'list-profiles'])

# ------------------------------------------
# ------------------------------------------

def dev_kube():
    cabecalho_sub('Listando os Clusters')
    executar_comando(['kind', 'get', 'clusters'])
    cabecalho_sub('Dados de context do kubectx')
    executar_comando(['kubectl', 'config', 'get-contexts'])

def list_helm():
    cabecalho_sub('Listando Dados do Helm')
    executar_comando(['helm', 'list'])

def list_version():
    cabecalho_sub('Listar versões instaladas')
    executar_comando(['docker', '--version'])
    executar_comando(['python3', '--version'])
    executar_comando(['aws', '--version'])
    executar_comando(['kubectl', 'version', '--client', '--output=yaml'])
    executar_comando(['kubectl', 'version', '--client'])
    executar_comando(['helm', 'version'])


# ------------------------------------------
# Menu geral
# ------------------------------------------

def menu():
    while True:
        cabecalho_menu("\nEscolha uma opção:\n")
        print("1 - Iniciar docker")
        print("2 - Parar docker")
        print("3 - Dados Docker")
        print("4 - Status Docker")
        print("5 - Dados AWS CLI")
        print("6 - Listar Versões")
        print("7 - Dados EKS")
        print("8 - Dados Helm")
        print("9 - VS code")
        print("10 - Sair")

        opcao = input("\nDigite o número da opção: ")

        if opcao == '1':
            fun_start_docker()
        elif opcao == '2':
            fun_stop_docker()
        elif opcao == '3':
            dev_docker()
        elif opcao == '4':
            executar_comando(['service', 'docker', 'status', 'status'])
            #executar_comando(['docker', 'ps','|', 'grep', 'portainerer'])
        elif opcao == '5':
            listar_credenciais()
            listar_perfis()
        elif opcao == '6':
            list_version()
        elif opcao == '7':
            dev_kube()
        elif opcao == '8':
            list_helm()
        elif opcao == '9':
            comando_vscode()
        elif opcao == '10':
            cabecalho_cor("\nSaindo... Até a próxima!\n")
            break
        else:
            print("Opção inválida, tente novamente.")


# Executar o menu interativo
if __name__ == "__main__":
    menu()