# ------------------------------------------
# import
# ------------------------------------------

import subprocess
import os
from termcolor import colored

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