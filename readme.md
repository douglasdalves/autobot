# alias usadps
nano ~/.bashrc
alias autobot='/root/devops/automation-py/autobot/autobot-wsl.py'
Salve e feche o editor (em nano, pressione CTRL + X, depois Y, e depois ENTER).
source ~/.bashrc

# Editar /etc/wsl.conf na distro WSL2:
[boot]
systemd=true

# anotações docker
#Você pode desabilitar o serviço Docker para que ele não inicie automaticamente:
```bash
sudo systemctl disable docker.service
sudo systemctl disable docker.socket
systemctl is-enabled docker
```

# maquina sem user root
```bash
sudo visudo
your_username ALL=NOPASSWD: /bin/systemctl start docker, /bin/systemctl stop docker
whoami
```

# outas anotações
```bash
docker ps --filter "name=kind"
docker pause $(docker ps --filter "name=kind" -q)
docker unpause $(docker ps -a --filter "name=kind" -q)
```

# usar o aws configure sso na v1 do cli
```bash
which aws
ls -l $(which aws)
/usr/local/bin/aws --version
nano ~/.profile
export PATH=/usr/local/bin:$PATH
source ~/.profile
aws --version
```

# brew
sudo -u usobrew brew install nginx
