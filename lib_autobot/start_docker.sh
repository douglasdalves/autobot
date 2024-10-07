#!/bin/bash

#// Teste para automatizar o docker via WSL

#// docker variaveis

status_docker="service docker status"
subindo_docker="sudo service docker start"
stop_docker="sudo service docker stop"


#// containers
docker_ps="docker ps -a"




#// portainer variaveis
grep_portainer="docker ps | grep portainer"
portainer_stop="docker stop portainer"
log_portainer="docker logs -n 3 portainer"


#// menu para automatizar
fun_menu(){
    echo && echo "Automatizando o docker no WSL"
    echo && echo "Status atual:"
    $status_docker
    echo
    echo "Startando o serviço" && $subindo_docker
    echo
    $log_portainer
}

fun_menu