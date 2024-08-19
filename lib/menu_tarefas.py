#------------------------------------------------

from variaveis.interface_config import *


#------------------------------------------------

# Dados menu
t_menu1 = 'Pacotes do Python'
t_menu2 = 'Variavel Ambiente'
t_menu3 = 'Install Programas'
t_menu4 = 'Dados WSL'
t_menu5 = 'Dados Docker'
t_menu6 = 'Dados AWS cli'
t_menu7 = 'Dados Kubernetes'
t_menu8 = 'Abrir o vsCode'

#------------------------------------------------
#Codigo do menu 2

def abrir_taref():
    while True:
        resposta = menu_secund([t_menu1,t_menu2,t_menu3,t_menu4,t_menu5,t_menu6,t_menu7,t_menu8,opcao_retorno])
        if resposta == 1:
            os.system('cls') or None
            exec(open("./funcoes_tarefas/pacotes_detalhes.py").read())
        elif resposta == 2:
            os.system('cls') or None
            exec(open("./funcoes_tarefas/func_variavel.py").read())
        elif resposta == 3:
            os.system('cls') or None
            os.startfile(myfile_programas)
        elif resposta == 4:
            os.system('cls') or None
            dev_wsl()
        elif resposta == 5:
            os.system('cls') or None
            dev_docker()
        elif resposta == 6:
            listar_credenciais()
            listar_configuracoes()
            versao_cli()
            listar_perfis()
        elif resposta == 7:
            dev_kube()
        elif resposta == 8:
            os.system('code .')
        elif resposta == 9:
            frase_retorno()
        else:
            leia_opcao()
            sleep(2)



def cabecalho1(texto):
    print(colored(f"--- {texto} ---", 'green', attrs=['bold']))


def dev_vagrant():
    cabecalho1('Funcoes em Vagrant')
    os.system('vagrant global-status')
    print('\n')
    os.system('vagrant box list')

def dev_docker():
    cabecalho1('Funcoes em Docker')
    os.system('wsl docker ps -a')
    print('\n')
    cabecalho1('Listando Imagens Docker')
    os.system('wsl docker images')
    print('\n')

def dev_wsl():
    cabecalho1('Funcoes em WSL')
    os.system('wsl -l -v')
    print('\n')

def listar_credenciais():
    cabecalho1('Listando credenciais AWS')
    os.system('cat ~/.aws/credentials')

def listar_configuracoes():
    cabecalho1('Listando configurações AWS')
    os.system('cat ~/.aws/config')

def versao_cli():
    cabecalho1('Versão do AWS CLI')
    os.system('aws configure --version')

def listar_perfis():
    cabecalho1('Listando perfis configurados')
    os.system('aws configure list-profiles')

def dev_kube():
    cabecalho1('Listando os Clusters')
    os.system('wsl kind get clusters')
    cabecalho1('Dados de context do kubectx')
    os.system('wsl kubectl config get-contexts')