
import subprocess
import time
from termcolor import colored
from variaveis.interface_config import *


caminho_log_ping = r'C:/scripts_logs'
caminho_fun_seanet = r'C:/scripts'
LOG_PING = datetime.now().strftime('Ping40seanet_%d_%m_%Y_%H_%M_%S.log')


func_cabecalho('Ping 40x para o IP da Seanet')
gerar_ping = subprocess.run(["ping", "-n", "40", ping_seanet])
os.chdir(caminho_log_ping)
os.system('ping -n 40 186.251.248.1 > ping.log')
os.rename('ping.log', LOG_PING)
os.chdir(caminho_fun_seanet)
dados_pc()