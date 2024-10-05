#!/usr/bin/env python3

# ------------------------------------------
# import
# ------------------------------------------

import subprocess
import os
from termcolor import colored

# ------------------------------------------
# libs
# ------------------------------------------

def executar_comando(comando, shell=False):
    try:
        resultado = subprocess.run(comando, shell=shell, check=True, text=True, capture_output=True)
        print(resultado.stdout)
    except subprocess.CalledProcessError as e:
        print(colored(f"Erro ao executar o comando: {comando}\nErro: {e.stderr}", 'red'))
    except Exception as e:
        print(colored(f"Ocorreu um erro inesperado: {e}", 'red'))

def cabecalho1(texto):
    print(colored(f"--- {texto} ---", 'green', attrs=['bold']))

# ------------------------------------------
# ------------------------------------------

def dev_docker():
    cabecalho1('Funções em Docker')
    executar_comando(['docker', 'ps', '-a'])
    print('\n')
    cabecalho1('Listando Imagens Docker')
    executar_comando(['docker', 'images'])
    print('\n')

# ------------------------------------------
# ------------------------------------------

def listar_credenciais():
    cabecalho1('Listando credenciais AWS (PARCIAL)')
    try:
        with open(os.path.expanduser("~/.aws/credentials"), 'r') as f:
            for line in f:
                if line.startswith("["):
                    print(colored(line.strip(), 'yellow'))  # Mostra apenas o nome dos perfis
    except FileNotFoundError:
        print(colored('Arquivo de credenciais não encontrado.', 'red'))

def listar_configuracoes():
    cabecalho1('Listando configurações AWS')
    executar_comando(['cat', os.path.expanduser("~/.aws/config")], shell=True)

def listar_perfis():
    cabecalho1('Listando perfis configurados')
    executar_comando(['aws', 'configure', 'list-profiles'])

# ------------------------------------------
# ------------------------------------------

def dev_kube():
    cabecalho1('Listando os Clusters')
    executar_comando(['kind', 'get', 'clusters'])
    cabecalho1('Dados de context do kubectx')
    executar_comando(['kubectl', 'config', 'get-contexts'])

def list_helm():
    cabecalho1('Listando Dados do Helm')
    executar_comando(['helm', 'list'])

def list_version():
    cabecalho1('Listar versões instaladas')
    executar_comando(['docker', '--version'])
    executar_comando(['python3', '--version'])
    executar_comando(['aws', '--version'])
    executar_comando(['kubectl', 'version', '--client', '--output=yaml'])
    executar_comando(['kubectl', 'version', '--client'])
    executar_comando(['helm', '--version'])


# ------------------------------------------
# Menu
# ------------------------------------------

def menu():
    while True:
        print("\nEscolha uma opção:")
        print("1 - Iniciar docker")
        print("2 - Parar docker")
        print("3 - Dados Docker")
        print("4 - Dados AWS CLI")
        print("5 - Listar Versões")
        print("6 - Dados EKS")
        print("7 - Dados Helm")
        print("8 - Sair")

        opcao = input("Digite o número da opção: ")

        if opcao == '1':
            print('teste')
        elif opcao == '2':
            print('teste')
        elif opcao == '3':
            dev_docker()
        elif opcao == '4':
            listar_credenciais()
            listar_perfis()
        elif opcao == '5':
            list_version()
        elif opcao == '6':
            dev_kube()
        elif opcao == '7':
            list_helm()
        elif opcao == '8':
            print("Saindo... Até a próxima!")
            break
        else:
            print("Opção inválida, tente novamente.")


# Executar o menu interativo
if __name__ == "__main__":
    menu()