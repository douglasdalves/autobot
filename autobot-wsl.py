#!/usr/bin/env python3


# ------------------------------------------
# libs
# ------------------------------------------

from lib_autobot.docker_comandos import fun_start_docker
from lib_autobot.docker_comandos import fun_stop_docker
from lib_autobot.docker_comandos import verificar_docker_running
from lib_autobot.docker_comandos import verificar_docker_dados
from lib_autobot.other_comands import listar_credenciais
from lib_autobot.other_comands import listar_perfis
from lib_autobot.other_comands import list_version
from lib_autobot.other_comands import verificar_ambiente_e_executar_versao
from lib_autobot.kube_comandos import dev_kube
from lib_autobot.kube_comandos import list_helm

from lib_autobot.lib_comandos import *


# ------------------------------------------
# Menu geral
# ------------------------------------------

# Função para exibir o cabeçalho do menu
def menu():
    while True:
        cabecalho_menu("\nEscolha uma opção:\n")
        print("1 - Start Docker")
        print("2 - Stop Docker")
        print("3 - Status Docker")
        print("4 - Data Docker")        
        print("5 - Data AWS CLI")
        print("6 - List Version")
        print("7 - Data EKS")
        print("8 - Data Helm")
        print("9 - Open VS code")
        print("10 - Exit\n")

        opcao = input("\nDigite o número da opção: ")

        if opcao == '1':
            fun_start_docker()
        elif opcao == '2':
            fun_stop_docker()
        elif opcao == '3':
            verificar_docker_running()
        elif opcao == '4':
            verificar_docker_dados()
        elif opcao == '5':
            listar_credenciais()
            listar_perfis()
        elif opcao == '6':
            list_version()
            verificar_ambiente_e_executar_versao()
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