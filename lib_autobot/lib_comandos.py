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


def ambiente_atual():
    # Windows (cmd, PowerShell ou Git Bash)
    if os.name == "nt":
        return "windows"

    # WSL (qualquer distro dentro do Windows)
    try:
        with open("/proc/version", "r") as f:
            if "microsoft" in f.read().lower():
                return "wsl"
    except:
        pass

    # Linux puro
    return "linux"

def comando_vscode():
    ambientes = ambiente_atual()

    # Caminhos usados por você:
    caminho_windows = "C:/usebash/devops/autobot"
    caminho_linux   = "/root/devops/automation-py/autobot"

    if ambientes == "windows":
        caminho = caminho_windows
        comando = ["code.cmd", "."]

    elif ambientes == "wsl":
        caminho = caminho_linux
        comando = ["code", "."]

    else:  # Linux puro
        caminho = caminho_linux
        comando = ["code", "."]

    if not os.path.exists(caminho):
        print(f"O caminho não existe no ambiente {ambientes}: {caminho}")
        return

    try:
        os.chdir(caminho)
        executar_comando(comando)
        print(f"VSCode aberto ({ambientes}) no diretório: {caminho}")
    except Exception as e:
        print(f"Erro ao abrir VSCode: {e}")


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
