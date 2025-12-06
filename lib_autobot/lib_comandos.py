# ------------------------------------------
# import
# ------------------------------------------

import subprocess
import os
from termcolor import colored
from time import sleep
import time
import yaml

# ------------------------------------------
# libs - config

def carregar_config():
    # Caminho do arquivo atual (lib_comandos.py)
    base_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Caminho completo para o config.yaml na mesma pasta
    config_path = os.path.join(base_dir, "config.yaml")

    if not os.path.exists(config_path):
        raise FileNotFoundError(f"config.yaml não encontrado em: {config_path}")

    with open(config_path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


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
    cfg = carregar_config()
    env = ambiente_atual()

    if env == "windows":
        path = cfg["paths"]["windows"]
        cmd  = [cfg["vscode"]["windows_command"], "."]
    else:
        path = cfg["paths"]["linux"]
        cmd  = [cfg["vscode"]["linux_command"], "."]

    if not os.path.exists(path):
        print(f"⚠ Caminho não existe para {env}: {path}")
        return

    os.chdir(path)
    executar_comando(cmd)

    print(f"✔ VSCode aberto ({env}) em: {path}")


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
    print(colored("Executando tarefa:", "green"))
    print ("✔  Ambiente correto detectado.")

def acao_para_ambiente_errado():
    print(colored("Ignorando tarefa:", "red"))
    print ("✘  Ambiente incorreto detectado.")




