# ------------------------------------------
# Imports
# ------------------------------------------

from lib_autobot.lib_comandos import *

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
    try:
        listaraws = executar_comando(['aws', 'configure', 'list-profiles'])
        
        # Verifica se a saída contém a palavra 'running'
        if 'Erro' or 'erro' in listaraws.stdout:
            print(colored(f"Em desenvolvimento", 'blue'))
            executar_comando(['aws', 'configure', 'list-profiles'])
        else:
            cabecalho_sub('Listando perfis configurados')
    except Exception as e:
        print(f"Ocorreu um erro: {e}")



# ------------------------------------------
# ------------------------------------------

def listar_versao(nome, comando):
    cabecalho_cor(f"Versão {nome}")
    executar_comando(comando)

def verificar_ambiente_e_executar_versao():
    usuario_host = comando_host()
    
    if usuario_host == "douglas@ACT9880":
        acao_para_ambiente_correto()
        listar_versao('ASRE cli', ['asre', 'version'])
    elif usuario_host == "douglas.alves@ACT9880":
        acao_para_ambiente_correto()
        listar_versao('ASRE cli', ['asre', 'version'])
    else:
        acao_para_ambiente_errado()


def list_version():
    cabecalho_sub('Listar versões instaladas')
    
    versoes = {
        'Git': ['git', '--version'],
        'Docker': ['docker', '--version'],
        'Python': ['python3', '--version'],
        'AWS cli': ['aws', '--version'],
        'Kubectl': ['kubectl', 'version', '--client', '--output=yaml'],
        'K9s': ['k9s', 'version'],
        'Helm': ['helm', 'version']  
    }
    
    for nome, comando in versoes.items():
        listar_versao(nome, comando)