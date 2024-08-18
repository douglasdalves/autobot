#------------------------------------------------
#Importacao de dados

from email.mime import application
from lib.menu_tarefas import abrir_taref
from automacao_sh import *
from variaveis.interface_config import *
from time import sleep

from termcolor import colored
from funcoes import *
from lib import *

#------------------------------------------------
#

myfile_cp_logs = r'C:/scripts_logs'

# Dados menu em lista
mlist = ['Testes de Conexao', 
         'Agilizando Tarefas', 
         'Status da WSL', 
         'Stop do WSL2',
         'Start docker', 
         'Stop docker',
         'Captura de Tela', 
         'Sair']


#------------------------------------------------
#Codigo do menu principal


while True:
    resposta = menu([mlist[0], mlist[1], mlist[2], mlist[3], mlist[4], mlist[5], mlist[6], mlist[7]])
    if resposta == 1:
        os.system('cls') or None
        exec(open("./funcoes/conexao_seanet.py").read())
    elif resposta == 2:
        os.system('cls') or None
        abrir_taref()
    elif resposta == 3:
        os.system('cls') or None
        wsl_status()
    elif resposta == 4:
        os.system('cls') or None
        print('\n','Stop da WSL2','\n')
        os.system('wsl --shutdown && wsl -l -v')
    elif resposta == 5:
        os.system('cls') or None
        subprocess.run(myfile_docker, shell=True)
        os.system('wsl docker ps')
        print('\n')
    elif resposta == 6:
        os.system('cls') or None
        os.system('wsl docker ps')
        subprocess.run(myfile_stop, shell=True)
        print('\n')
        os.system('wsl docker ps')
    elif resposta == 7:
        print
    elif resposta == 8:
        funcao_sair()
    else:
        leia_opcao()
        sleep(2)


