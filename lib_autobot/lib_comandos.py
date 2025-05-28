# ------------------------------------------
# import
# ------------------------------------------

import subprocess
import os
from termcolor import colored
from time import sleep
import time

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
# libs - func
# ------------------------------------------

# Função para executar comandos no terminal
def run_command(cmd):
    return subprocess.check_output(cmd, shell=True, text=True).strip()

def comando_host():
    usuario = run_command("whoami")
    host = run_command("hostname")
    return f"{usuario}@{host}"

def acao_para_ambiente_correto():
    print(colored("Executando tarefa específica no ambiente correto!", "green"))

def acao_para_ambiente_errado():
    print(colored("Ignorando tarefa: ambiente não corresponde ao esperado.", "red"))
