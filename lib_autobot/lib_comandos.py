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
    caminhos = [
        "C:/usebash/devops/autobot",
        "/root/devops/automation-py/autobot"
    ]

    caminho_existente = next((c for c in caminhos if os.path.exists(c)), None)

    if not caminho_existente:
        print("Nenhum dos caminhos configurados existe.")
        return

    try:
        os.chdir(caminho_existente)

        # USA O code.cmd em Windows/Git Bash
        executar_comando(["code.cmd", "."])

        print(f"VSCode aberto no diretório: {caminho_existente}")
    except Exception as e:
        print(f"Erro ao abrir VSCode no caminho {caminho_existente}: {e}")



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
    print(colored("Executando tarefa: Ação específica no ambiente esperado!", "green"))

def acao_para_ambiente_errado():
    print(colored("Ignorando tarefa: Ambiente não corresponde ao esperado.", "red"))
