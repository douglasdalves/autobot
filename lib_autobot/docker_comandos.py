# ------------------------------------------
# import
# ------------------------------------------

from lib_autobot.lib_comandos import *

# ------------------------------------------
# ------------------------------------------

# Variáveis docker
status_docker = "service docker status"
subindo_docker = "service docker start"
stop_docker = "service docker stop"

# Containers
docker_ps = "docker ps -a"
docker_log = "docker logs"

# Variáveis portainer
grep_portainer = "docker ps | grep portainer"
portainer_stop = "docker stop portainer"
log_portainer = "docker logs -n 3 portainer"

start_ui_apache = "docker run -d -p 8080:8080 -e DYNAMIC_CONFIG_ENABLED=true -v kafka-ui-data:/etc/kafkaui provectuslabs/kafka-ui"

# ------------------------------------------
# ------------------------------------------

def verificar_docker_running():
    try:
        # Executa o comando 'service docker status'
        result = subprocess.run(['service', 'docker', 'status'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Verifica se a saída contém a palavra 'running'
        if 'is running' in result.stdout:
            print(colored(f"Docker está rodando.", 'blue'))
        else:
            print(colored(f"Docker não está rodando.", 'red'))
    except Exception as e:
        print(f"Ocorreu um erro: {e}")

# ------------------------------------------

def dev_docker():
    cabecalho_sub('Funções em Docker')
    executar_comando(['docker', 'ps', '-a'])
    print('\n')
    cabecalho_sub('Listando Imagens Docker')
    executar_comando(['docker', 'images'])
    print('\n')


def verificar_docker_dados():
    try:
        # Executa o comando 'service docker status'
        result = subprocess.run(['service', 'docker', 'status'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Verifica se a saída contém a palavra 'running'
        if 'is running' in result.stdout:
            dev_docker()
        else:
            print(colored(f"O Docker deve estar rodando para retornar o status.", 'red'))
    except Exception as e:
        print(f"Ocorreu um erro: {e}")

# ------------------------------------------

# Função para executar comandos no terminal
def run_command(command):
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        return e.output

# ------------------------------------------
# ------------------------------------------


import os
from time import sleep


def verificar_ambiente_e_executar_uimsk():
    usuario_host = comando_host()
    
    if usuario_host == "douglas@ACT9880":
        acao_para_ambiente_correto()
        sleep(25)
        print(run_command(start_ui_apache))
    else:
        acao_para_ambiente_errado()


def run_command(command):
    return os.popen(command).read()

def fun_start_docker():
    print("\nAutomatizando o docker no WSL")
    
    print("\nStatus atual:")
    print(run_command(status_docker))
    
    print("\nStartando o serviço")
    print(run_command(subindo_docker))
    
    print("\nStatus do Portainer:")
    sleep(20)
    print(run_command(grep_portainer))
    verificar_ambiente_e_executar_uimsk()

# Executar a função de menu
if __name__ == "__main__":
    fun_start_docker()


# ------------------------------------------
# ------------------------------------------


# Função de menu STOP
def fun_stop_docker():
    print("\nAutomatizando o docker no WSL")
    
    # Exibir o status atual do Docker
    print("\nStatus atual:")
    print(run_command(status_docker))
    print(run_command(grep_portainer))
    
    # Parar o container do Portainer
    print("\nParando o Portainer")
    print(run_command(portainer_stop))
    time.sleep(10)
        
    # Parar o serviço do Docker
    print("\nParando o serviço Docker")
    print(run_command(stop_docker))
    time.sleep(10)
    print(run_command(status_docker))    

# Executar o menu
if __name__ == "__main__":
    fun_stop_docker()