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
from lib_autobot.docker_comandos import verificar_docker_running
from lib_autobot.lib_comandos import executar_comando
from lib_autobot.lib_comandos import comando_vscode


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

def verificar_kind_running():
    try:
        # Executa o comando 'kind get clusters'
        result = subprocess.run(['kind', 'get', 'clusters'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Verifica se a saída contém clusters
        if result.stdout.strip():  # Se houver algo na saída, o kind está rodando
            print(colored(f"King está rodando.", 'blue'))
            executar_comando(['kind', 'get', 'clusters'])
        else:
            print(colored(f"King não está rodando.", 'red'))
    except Exception as e:
        print(f"Ocorreu um erro: {e}")


def verificar_helm_running():
    try:
        # Executa o comando 'kind get clusters'
        result = subprocess.run(['helm', 'list'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Verifica se a saída contém clusters
        if result.stdout.strip():  # Se houver algo na saída, o kind está rodando
            print(colored(f"Helm Disponível.", 'blue'))
            executar_comando(['helm', 'list'])
        else:
            print(colored(f"Helm não está Disponível.", 'red'))
    except Exception as e:
        print(f"Ocorreu um erro: {e}")


# Executa o comando kubectl config get-contexts
# Passa o resultado para awk '{print $1, $2}'
# Decodifica o resultado de bytes para string
def consulta_kubectl():
    process1 = subprocess.Popen(['kubectl', 'config', 'get-contexts'], stdout=subprocess.PIPE)
    process2 = subprocess.Popen(['grep', '-v', 'NAME'], stdin=process1.stdout, stdout=subprocess.PIPE)
    process3 = subprocess.Popen(['awk', '{print $1, $2}'], stdin=process2.stdout, stdout=subprocess.PIPE)
    output, error = process3.communicate()
    print(output.decode('utf-8'))


def dev_kube():
    cabecalho_sub('Listando Kind Clusters')
    verificar_kind_running()
    cabecalho_sub('Dados de context do kubectx')
    consulta_kubectl()

def list_helm():
    cabecalho_sub('Listando Dados do Helm')
    #executar_comando(['helm', 'list'])
    verificar_helm_running()

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
        print("3 - Status Docker")
        print("4 - Dados Docker")        
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
            verificar_docker_running()
            #executar_comando(['docker', 'ps','|', 'grep', 'portainerer'])
        elif opcao == '4':
            dev_docker()
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