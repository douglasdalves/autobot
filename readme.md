nano ~/.bashrc
alias autobot='/root/devops/automation-py/autobot/autobot-wsl.py'
Salve e feche o editor (em nano, pressione CTRL + X, depois Y, e depois ENTER).
source ~/.bashrc

# Editar /etc/wsl.conf na distro WSL2:
[boot]
systemd=true


#Você pode desabilitar o serviço Docker para que ele não inicie automaticamente:
sudo systemctl disable docker.service
sudo systemctl disable docker.socket
systemctl is-enabled docker


#maquina sem user root
sudo visudo
your_username ALL=NOPASSWD: /bin/systemctl start docker, /bin/systemctl stop docker
whoami
nano ~/.bashrc
alias startdocker='sudo /bin/systemctl start docker'
alias stopdocker='sudo /bin/systemctl stop docker'


docker ps --filter "name=kind"
docker pause $(docker ps --filter "name=kind" -q)
docker unpause $(docker ps -a --filter "name=kind" -q)
