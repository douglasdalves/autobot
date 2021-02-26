import os

def linha(tam = 42):
    return '-' * tam

def cabecalho (txt):
    print('\n')
    print(linha())
    print(txt.center(42))
    print(linha())


cabecalho('Verificando o Acesso ao DNS do Google')
os.system('tracert -d -w 2000 dns.google')

cabecalho('Consulta de DNS com Site')
print('\n')
os.system('nslookup')

os.system('echo Data do teste: %date%')
os.system('echo Hora do teste: %time%')
os.system('echo Equipamento testado: %computername%')
os.system('echo Usuario do windows: %username%')
print('\n')