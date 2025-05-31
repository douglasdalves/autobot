# ------------------------------------------
# Imports
# ------------------------------------------

from lib_autobot.lib_comandos import *

# ------------------------------------------
# Variáveis Docker e Containers
# ------------------------------------------

status_docker = "systemctl status docker"
subindo_docker = "systemctl start docker"
stop_docker = "systemctl stop docker"

docker_ps = "docker ps -a"
docker_log = "docker logs"

# Variáveis do Portainer
grep_portainer = "docker ps | grep portainer"
portainer_stop = "docker stop portainer"
log_portainer = "docker logs -n 3 portainer"

# Kafka UI
start_ui_apache = (
    "docker run -d -p 8080:8080 -e DYNAMIC_CONFIG_ENABLED=true "
    "-v kafka-ui-data:/etc/kafkaui provectuslabs/kafka-ui"
)

# ------------------------------------------
# Execução de comandos
# ------------------------------------------

def run_command(command):
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        return e.output

# ------------------------------------------
# Verificações e status do Docker
# ------------------------------------------

def docker_esta_ativo():
    try:
        result = subprocess.run(['systemctl', 'show', 'docker', '--property=ActiveState'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        return "ActiveState=active" in result.stdout.strip()
    except Exception as e:
        print(f"Erro ao verificar status do Docker: {e}")
        return False


def verificar_docker_running():
    if docker_esta_ativo():
        print(colored("Docker está rodando.", 'blue'))
    else:
        print(colored("Docker não está rodando.", 'red'))


def verificar_docker_dados():
    if docker_esta_ativo():
        cabecalho_sub('Funções em Docker')
        executar_comando(['docker', 'ps', '-a'])
        print('\n')
        cabecalho_sub('Listando Imagens Docker')
        executar_comando(['docker', 'images'])
        print('\n')
    else:
        print(colored("O Docker deve estar rodando para retornar o status.", 'red'))


# ------------------------------------------
# Execução do Kafka UI se ambiente correto
# ------------------------------------------

def verificar_ambiente_e_executar_uimsk():
    usuario_host = comando_host()
    
    if usuario_host == "douglas@ACT9880":
        acao_para_ambiente_correto()
        sleep(25)
        print(run_command(start_ui_apache))
    else:
        acao_para_ambiente_errado()

# ------------------------------------------
# Funções de start e stop do Docker
# ------------------------------------------

def fun_start_docker():
    print("\nValidando o Docker...")

    if docker_esta_ativo():
        print(colored("Docker já está rodando.", 'blue'))
    else:
        print(colored("Docker não está rodando, será Iniciado\n", 'red'))
        print(run_command(subindo_docker))

        print("\nAguardando inicialização do Portainer...")
        sleep(20)
        print(run_command(grep_portainer))

        verificar_ambiente_e_executar_uimsk()
        verificar_docker_running()


def fun_stop_docker():
    print("\nValidando o Docker...")

    if docker_esta_ativo():
        print(colored("Docker já está rodando, será encerrado", 'blue'))
    
        print(run_command(portainer_stop))
        sleep(10)
        
        print("\nParando o serviço Docker...")
        print(run_command(stop_docker))
        sleep(10)

        print("\nStatus atual do Docker:")
        verificar_docker_running()
    else:
        print(colored("Docker não está rodando\n", 'red'))
