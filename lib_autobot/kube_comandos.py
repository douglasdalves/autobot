# ------------------------------------------
# import
# ------------------------------------------

from lib_autobot.lib_comandos import *

# ------------------------------------------
# ------------------------------------------

def verificar_kind_running():
    try:
        # Executa o comando 'kind get clusters'
        result = subprocess.run(['kind', 'get', 'clusters'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Verifica se a saída contém clusters
        if result.stdout.strip():  # Se houver algo na saída, o kind está rodando
            print(colored(f"King está rodando.", 'blue'))
            executar_comando(['kind', 'get', 'clusters'])
        else:
            print(colored(f"King não está rodando.", 'red'))
    except Exception as e:
        print(f"Ocorreu um erro: {e}")


# ------------------------------------------

# Executa o comando kubectl config get-contexts
# Passa o resultado para awk '{print $1, $2}'
# Decodifica o resultado de bytes para string
def consulta_kubectl():
    process1 = subprocess.Popen(['kubectl', 'config', 'get-contexts'], stdout=subprocess.PIPE)
    process2 = subprocess.Popen(['grep', '-v', 'NAME'], stdin=process1.stdout, stdout=subprocess.PIPE)
    process3 = subprocess.Popen(['awk', '{print $1, aaaa, $2}'], stdin=process2.stdout, stdout=subprocess.PIPE)
    output, error = process3.communicate()
    print(output.decode('utf-8'))

# ------------------------------------------
#consultas no eks x quantidade de dados

def run_command(command):
    """Executes a shell command and returns the output."""
    try:
        result = subprocess.check_output(command, shell=True, text=True)
        return result.strip()
    except subprocess.CalledProcessError as e:
        return f"Erro ao executar o comando: {e}"

def count_pods_by_status():
    """Counts pods by their status."""
    running_pods = run_command("kubectl get pods -A --field-selector=status.phase=Running --no-headers | wc -l")
    non_running_pods = run_command("kubectl get pods -A --no-headers | grep -v 'Running' | wc -l")
    return running_pods, non_running_pods

def count_nodes_by_status():
    """Counts nodes by their Ready status."""
    ready_nodes = run_command("kubectl get nodes --no-headers | grep ' Ready' | wc -l")
    non_ready_nodes = run_command("kubectl get nodes --no-headers | grep -v ' Ready' | wc -l")
    return ready_nodes, non_ready_nodes

def count_resources():
    """Counts various Kubernetes resources."""
    # Count pods and nodes by status
    running_pods, non_running_pods = count_pods_by_status()
    ready_nodes, non_ready_nodes = count_nodes_by_status()
    # Consulta os recursos do cluster
    pod_count = run_command("kubectl get pods -A --no-headers | wc -l")
    node_count = run_command("kubectl get nodes --no-headers | wc -l")
    namespace_count = run_command("kubectl get namespaces --no-headers | wc -l")
    secret_count = run_command("kubectl get secrets -A --no-headers | wc -l")
    configmap_count = run_command("kubectl get configmaps -A --no-headers | wc -l")

    # Exibe os resultados
    print(f"Pods existentes no cluster: {pod_count}")
    print(f"Pods em outros estados: {non_running_pods}")
    print(f"Nós existentes no cluster: {node_count}")
    print(f"Nodes em outros estados: {non_ready_nodes}")
    print(f"Namespaces existentes no cluster: {namespace_count}")
    print(f"Secrets existentes no cluster: {secret_count}")
    print(f"ConfigMaps existentes no cluster: {configmap_count}")

# ------------------------------------------
#consultas no kind ou eks para o helm

def verificar_helm_running():
    try:
        # Executa o comando 'kind get clusters'
        result = subprocess.run(['helm', 'list'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        
        # Verifica se a saída contém clusters
        if result.stdout.strip():  # Se houver algo na saída, o kind está rodando
            print(colored(f"Helm Disponível.", 'blue'))
            executar_comando(['helm', 'list'])
        else:
            print(colored(f"Helm não está Disponível.", 'red'))
    except Exception as e:
        print(f"Ocorreu um erro: {e}")


def list_helm():
    cabecalho_sub('Listando Dados do Helm')
    #executar_comando(['helm', 'list'])
    verificar_helm_running()


# ------------------------------------------
#menu interno

def verificar_ambiente_e_executar():
    usuario_host = comando_host()
    
    if usuario_host == "douglas@ACT9880":
        acao_para_ambiente_correto()
        count_resources()
    else:
        acao_para_ambiente_errado()
   

def dev_kube():
    cabecalho_sub('Listando Kind Clusters')
    verificar_kind_running()
    cabecalho_sub('Dados de context do kubectx')
    consulta_kubectl()
    cabecalho_sub('Dados do kubernetes')
    # Chamada principal
    verificar_ambiente_e_executar()
    
    
