# Documentação Autobot

## Visão Geral do Projeto

O `autobot` é uma ferramenta de automação de linha de comando (CLI) desenvolvida em Python. Seu principal objetivo é simplificar e automatizar tarefas repetitivas de DevOps, oferecendo um menu interativo para gerenciar Docker, Kubernetes (com Kind e EKS), Helm e configurações da AWS.

A ferramenta é projetada como um assistente pessoal para um ambiente de desenvolvimento específico, contendo lógica e verificações que a personalizam para a máquina e usuário do desenvolvedor original (ex: `douglas@ACT9880`).

## Estrutura do Projeto

```
/root/devops/automation-py/autobot/
├───.gitignore
├───autobot-wsl.py
├───readme-docs.md
├───readme.md
├───.git/
├───infos-adicionais/
│   ├───alias_linux.txt
│   ├───analises.sh
│   └───...
└───lib_autobot/
    ├───docker_comandos.py
    ├───install_pacotes_helm.sh
    ├───install_pacotes_linux.sh
    ├───install_pacotes_wsl.sh
    ├───kube_comandos.py
    ├───lib_comandos.py
    ├───other_comands.py
    ├───remover_awscli.sh
    ├───requirements.txt
    └───__pycache__/
```

- **`autobot-wsl.py`**: O ponto de entrada principal da aplicação. Executa o menu interativo.
- **`lib_autobot/`**: Diretório que contém a lógica principal da aplicação, separada por domínios (Docker, Kube, etc.).
- **`infos-adicionais/`**: Contém scripts de apoio, anotações e consultas que não fazem parte do fluxo principal da aplicação.
- **`readme.md`**: Contém anotações sobre configuração de ambiente e alias.

## Componentes Principais

### `autobot-wsl.py`

Este é o script principal que o usuário executa. Ele importa as funções dos módulos na `lib_autobot` e apresenta um menu com as seguintes opções:
1.  Iniciar Docker
2.  Parar Docker
3.  Status do Docker
4.  Dados do Docker (containers e imagens)
5.  Dados da AWS CLI (credenciais e perfis)
6.  Listar Versões de ferramentas (Git, Docker, AWS CLI, etc.)
7.  Dados do EKS/Kubernetes
8.  Dados do Helm
9.  Abrir o projeto no VS Code
10. Sair

### `lib_autobot/lib_comandos.py`

Módulo de utilidades central. Fornece funções essenciais usadas em todo o projeto:
-   `executar_comando()`: Wrapper para o `subprocess.run` para executar comandos de shell.
-   Funções de formatação de saída: `cabecalho_sub()`, `cabecalho_cor()`, `cabecalho_menu()` para imprimir textos coloridos e formatados no terminal.
-   `comando_host()`: Retorna o nome do usuário e do host atual (`usuario@host`).
-   `comando_vscode()`: Abre o diretório do projeto no Visual Studio Code.

### `lib_autobot/docker_comandos.py`

Contém toda a lógica para interagir com o Docker.
-   `fun_start_docker()`: Inicia o serviço do Docker e, em ambientes específicos, sobe um container do Kafka UI.
-   `fun_stop_docker()`: Para os containers (Portainer, etc.) e o serviço do Docker.
-   `verificar_docker_running()`: Verifica se o serviço do Docker está ativo.
-   `verificar_docker_dados()`: Lista os containers e imagens do Docker.
-   **Nota:** Muitas funções aqui contêm lógica para verificar se estão rodando no ambiente `douglas@ACT9880` para executar ações específicas.

### `lib_autobot/kube_comandos.py`

Módulo para interagir com Kubernetes e Helm.
-   `dev_kube()`: Função principal que exibe um resumo do ambiente Kubernetes, incluindo clusters Kind, contextos `kubectl` e uma contagem de recursos.
-   `count_resources()`: Conta vários recursos do cluster (Pods, Nodes, Namespaces, etc.).
-   `list_helm()`: Lista os releases do Helm.
-   `verificar_kind_running()`: Verifica se há clusters do Kind em execução.

### `lib_autobot/other_comands.py`

Agrupa comandos diversos e verificações.
-   `list_version()`: Exibe a versão de várias ferramentas de CLI, como `git`, `docker`, `aws`, `kubectl`, `k9s` e `helm`.
-   `listar_credenciais()`: Lê e exibe os perfis do arquivo `~/.aws/credentials`.
-   `listar_perfis()`: Executa `aws configure list-profiles`.

## Como Usar

1.  **Configurar o Ambiente**: Certifique-se de que todas as dependências listadas em `lib_autobot/requirements.txt` e as ferramentas de CLI (Docker, kubectl, etc.) estejam instaladas.
2.  **Criar um Alias (Opcional)**: Para facilitar a execução, você pode criar um alias no seu `.bashrc` ou `.zshrc`, como sugerido no `readme.md`:
    ```bash
    alias autobot='/root/devops/automation-py/autobot/autobot-wsl.py'
    ```
3.  **Executar**: Execute o script principal no seu terminal:
    ```bash
    python3 /root/devops/automation-py/autobot/autobot-wsl.py
    ```
    Ou, se o alias foi criado:
    ```bash
    autobot
    ```
4.  **Navegar pelo Menu**: Escolha uma das opções numéricas para executar a automação desejada.

## Dependências

As seguintes bibliotecas Python são necessárias e estão listadas em `lib_autobot/requirements.txt`:

-   `pyautogui`
-   `pillow`
-   `termcolor`
-   `requests`
-   `tqdm`
-   `boto3`
-   `urllib3`
