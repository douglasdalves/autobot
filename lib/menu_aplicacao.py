#------------------------------------------------
#Importacao de dados

from platform import python_branch
from variaveis.interface_config import *
from funcoes.conexao import *
#from funcoes.browserbot_test import consulta_speed
from time import sleep
import os

##########
# exemplos

    #os.path(myfile.conexao_seanet.py)
    #subprocess.Popen(ping_telefones(), shell=True)
    #webbrowser.open_new_tab('www.speedtest.net')
    #exec(open("./funcoes/ping_seanet.py").read())

##########

#------------------------------------------------
#
# Variavel de links
myfile="C:/scripts/funcoes/conexao_seanet.py"
myfile_browser = r'C:/scripts/funcoes/browserbot.py'
myfile_browser1 = r'C:/scripts/funcoes/browserbot_test.py'

# Dados menu
t_menu = 'Abrir o Chrome para testes'
t_menu1 = 'Ping da Conexao'
t_menu2 = 'Conectividade - Smart home'
t_menu3 = 'Conectividade - Notebooks'
t_menu4 = 'Conectividade - Smartphones'
t_menu5 = 'Conectividade - Desktop'


#------------------------------------------------
#Codigo do menu 5

def abrir_aplic():
    while True:
        resposta = menu_secund([t_menu,t_menu1,t_menu2,t_menu3,t_menu4,t_menu5,opcao_captura,opcao_retorno])
        if resposta == 1:
            os.system('cls') or None
            print('{}'.format(op1), 'Abrindo o navegor padrao')
            test_conexao()
            #os.startfile(myfile_browser1)
            os.startfile(myfile_browser)
            print('\n')
        elif resposta == 2:
            os.system('cls') or None
            #os.system('start ./funcoes/conexao_seanet.py')
        elif resposta == 3:
            print('{}'.format(op3), 'Testar conectividade dos Smart homes')
            ping_smarthome()
        elif resposta == 4:
            print('{}'.format(op4), 'Testar a conectividade dos Notebooks')
            ping_not()
        elif resposta == 5:
            print('{}'.format(op5), 'Testar a conectividade dos Smartphones')
            ping_telefones()
        elif resposta == 6:
            print('{}'.format(op6), 'Testar a conectividade do Desktop')
            ping_desktop()
        elif resposta == 7:
            print('{}'.format(op7), 'Captura de Tela')
            gerar_print()
        elif resposta == 8:
            frase_retorno()
        else:
            leia_opcao()
            sleep(2)