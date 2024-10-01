import sys
import os
import subprocess
import platform
import getpass
import pyautogui

from time import sleep
from termcolor import colored
from datetime import datetime
from time import sleep
from tqdm import tqdm

#------------------------------------------------
# variaveis

espaco = print('\n')

myfile_saindo = r'C:/sistema_python/funcoes/saindo_sistema.py'
myfile_bkp_pip = r'C:/scripts_logs/info_pacotes/backupPIP_python.txt'


#--------------------------------------------
# variaveis das funcoes conexao

ping_seanet = '186.251.248.1'



#--------------------------------------------
#('Configuracoes do menu funcoes')

def func_cabecalho (txt):
    """
    -> Realiza a personalizacão de titulo
    : Abre uma linha de espaço
    : Printa uma linha em verde
    : Texto dentro das linhas
    """
    print('\n')
    print(colored('-' * 42, 'green'))
    print(txt.center(42))
    print(colored('-' * 42, 'green'))


#--------------------------------------------
# configuracao dados da maquina

def dados_pc():
    """
    -> Gera os dados de Data, Hora, Equipamento, Usuário
    : Coleta o datatime
    : Nome do equipamento
    : User do windows
    """
    data_e_hora_atuais = datetime.now()
    data_e_hora_em_texto = data_e_hora_atuais.strftime('%d/%m/%Y %H:%M')
    text_data = colored('Data e Hora do teste:', 'blue', attrs=['bold'])

    cpu = platform.node()
    text_cpu = colored('Equipamento do Teste:', 'blue', attrs=['bold'])

    user = getpass.getuser()
    text_user = colored('Usuario do Sistema:', 'blue', attrs=['bold'])

    print('\n','\n', '--------- Testes Concluidos ---------')
    print(f'{text_data} {data_e_hora_em_texto}')
    print(f'{text_cpu} {cpu}')
    print(f'{text_user} {user}', '\n')



#--------------------------------------------
## configuracoes das mensagens

def leiaInt(msg):
    """
    -> Apresenta as mensagens de erro ao usar o menu incorretamente
    : Le a entrada
    : valida a entrada
    : Retorna a mensagem adequada
    : Trabalha com a cor vermelha
    """
    while True:
        try:
            n = int(input(msg))
        except (ValueError, TypeError):
            print(colored('ERRO: Por favor, digite um numero inteiro valido.','red'))
            continue
        except (KeyboardInterrupt):
            print(colored('Usuario preferiu não digitar esse numero.','red'))
            return 0
        else:
            return n

def leia_opcao():
    print(colored('ERRO! Digite uma opção valida!','magenta'))

#--------------------------------------------
## configuracoes das opcoes

#---# ('Retornando para o menu principal')

#frase_retorno = 'Retornando para o menu principal'
fra1 = colored('Retornando para o menu principal', 'yellow', attrs=['bold'])

def retorno (txt):
    print(linha())
    print(txt.center(53))
    print(linha())
    print('\n')

opcao_retorno = colored('Retornar ao Home', 'blue')

def frase_retorno():
    os.system('cls') or None
    retorno('{}'.format(fra1))
    exec(open("sistema.py").read())
    
    

#---# funcao sair
def funcao_sair():
    """
    -> Funcao de sair da aplicacao do python
    : Abre espaco antes e depois da mensagem
    : Mensagem de aviso
    : Time para visualizar o processo
    : Parametro de sair - closed
    """
    print('\n')
    cabecalho_sup('Saindo do sistema... Até logo')
    print('\n')
    sleep(2)
    os.close()


#--------------------------------------------
#('Configuracoes do menu inicial')



def linha(tam = 42): ## usado por outros menus
    return '-' * tam

def cabecalho_sup (txt):
    print(linha())
    print(colored(txt.center(42),'cyan',attrs=['bold']))
    print(linha())

def cabecalho_inf (txt):
    print(linha())
    print(colored(txt.center(42),'green'))

def menu(lista):
    cabecalho_sup('MENU PRINCIPAL')
    c = 1
    for item in lista:
        print(f'{c} - {item}')
        c += 1
    cabecalho_inf('Escolha uma Opção')
    print(linha())
    opc = leiaInt("\nSua Opção: ")
    return opc


#--------------------------------------------
#('Configuracoes dos menus secudarios')

def cabeçalho (txt):
    print('-' * 42)
    print(colored(txt.center(42),'magenta'))
    print('-' * 42)

def menu_secund(lista):
    cabeçalho('Testes secundários')
    c = 1
    for item in lista:
        print(f'{c} - {item}')
        c += 1
    print('-' * 42)
    opc = leiaInt("\nSua Opção: ")
    return opc


#--------------------------------------------


#Linhas de personalizacao

myfile_docker = r'C:/sistema_python/automacao_sh/wsl_start_docker.sh'
myfile_stop = r'C:/sistema_python/automacao_sh/wsl_stop_docker.sh'

myfile_docker1 = r'C:/sistema_python/automacao_sh'

myfile_programas = r'C:/sistema_python/funcoes_tarefas/instal_programas.bat'


myfile_docker = r'C:/sistema_python/automacao_sh/wsl_start_docker.sh'
myfile_stop = r'C:/sistema_python/automacao_sh/wsl_stop_docker.sh'

myfile_docker1 = r'C:/sistema_python/automacao_sh'

#------------------------------------------------
# funções

def wsl_status():
    print('\n')
    subprocess.run(["wsl", "-l", "-v"])
    print('\n')


def limpar_tela():
    """
    Limpa a tela do terminal, compatível com sistemas Windows e Unix.
    """
    os.system('cls' if os.name == 'nt' else 'clear')
