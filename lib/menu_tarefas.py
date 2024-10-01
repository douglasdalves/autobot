#------------------------------------------------

from variaveis.interface_config import *


def executar_comando(comando, shell=False):
    try:
        resultado = subprocess.run(comando, shell=shell, check=True, text=True, capture_output=True)
        print(resultado.stdout)
    except subprocess.CalledProcessError as e:
        print(colored(f"Erro ao executar o comando: {comando}\nErro: {e.stderr}", 'red'))
    except Exception as e:
        print(colored(f"Ocorreu um erro inesperado: {e}", 'red'))

#------------------------------------------------


# Dados menu
t_menu1 = 'Pacotes do Python'
t_menu2 = 'Variavel Ambiente'
t_menu3 = 'Install Programas'
t_menu4 = 'Dados WSL'
t_menu5 = 'Dados Docker'
t_menu6 = 'Dados AWS cli'
t_menu7 = 'Dados Kubernetes'
t_menu8 = 'Dados Helm'
t_menu9 = 'Abrir o vsCode'

#------------------------------------------------
#Codigo do menu 2


def abrir_taref():
    while True:
        try:
            resposta = int(menu_secund([t_menu1, t_menu2, t_menu3, t_menu4, t_menu5, t_menu6, t_menu7, t_menu8,t_menu9 ,opcao_retorno]))
        except ValueError:
            print("Entrada inválida. Por favor, insira um número correspondente ao menu.")
            continue
        
        if resposta not in range(1, 10):
            print("Opção inválida. Tente novamente.")
        if resposta == 1:
            limpar_tela()
            exec(open("./funcoes_tarefas/pacotes_detalhes.py").read())
        elif resposta == 2:
            limpar_tela()
            exec(open("./funcoes_tarefas/func_variavel.py").read())
        elif resposta == 3:
            limpar_tela()
            os.startfile(myfile_programas)
        elif resposta == 4:
            limpar_tela()
            dev_wsl()
        elif resposta == 5:
            limpar_tela()
            dev_docker()
        elif resposta == 6:
            listar_credenciais()
            listar_configuracoes()
            versao_cli()
            listar_perfis()
        elif resposta == 7:
            dev_kube()
        elif resposta == 8:
            list_helm()
        elif resposta == 9:
            os.system('code .')
        elif resposta == 10:
            frase_retorno()
        else:
            leia_opcao()
            sleep(2)


def cabecalho1(texto):
    print(colored(f"--- {texto} ---", 'green', attrs=['bold']))


def dev_vagrant():
    cabecalho1('Funções em Vagrant')
    executar_comando(['vagrant', 'global-status'])
    print('\n')
    executar_comando(['vagrant', 'box', 'list'])

def dev_docker():
    cabecalho1('Funções em Docker')
    executar_comando(['wsl', 'docker', 'ps', '-a'])
    print('\n')
    cabecalho1('Listando Imagens Docker')
    executar_comando(['wsl', 'docker', 'images'])
    print('\n')


def dev_wsl():
    cabecalho1('Funções em WSL')
    executar_comando(['wsl', '-l', '-v'])
    print('\n')

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

def versao_cli():
    cabecalho1('Versão do AWS CLI')
    executar_comando(['aws', '--version'])

def listar_perfis():
    cabecalho1('Listando perfis configurados')
    executar_comando(['aws', 'configure', 'list-profiles'])

def dev_kube():
    cabecalho1('Listando os Clusters')
    executar_comando(['wsl', 'kind', 'get', 'clusters'])
    cabecalho1('Dados de context do kubectx')
    executar_comando(['wsl', 'kubectl', 'config', 'get-contexts'])

def list_helm():
    cabecalho1('Listando Dados do Helm')
    executar_comando(['wsl', 'helm', 'list'])


