#!/usr/bin/env bash
# Key-Value Store
EXAREME_KEYSTORE="exareme-keystore:8500"

# Docker internal folder for the Exareme data
DOCKER_DATA_FOLDER="/root/exareme/data/"

# Portainer
PORTAINER_PORT="9000"
PORTAINER_IMAGE="portainer/portainer"
PORTAINER_VERSION=":latest"
PORTAINER_DATA=$pwd"/portainer"

FEDERATION_ROLE="master"

#Check if data_path exist
if [[ -s dataPath.txt ]]; then
    :
else
    echo "What is the data_path for host machine?"
    read answer
    #Check that path ends with /
    if [[ "${answer: -1}"  != "/" ]]; then
            answer=${answer}"/"
    fi
    echo LOCAL_DATA_FOLDER=${answer} > dataPath.txt
fi

LOCAL_DATA_FOLDER=$(cat dataPath.txt | cut -d '=' -f 2)


chmod 755 *.sh

#Check if Exareme docker image exists in file
if [[ -s exareme.yaml ]]; then
    :
else
    . ./exareme.sh
fi

if [[ $(sudo docker info | grep Swarm | grep inactive*) != '' ]]; then
    echo -e "\nInitialize Swarm.."
    sudo docker swarm init --advertise-addr=$(wget http://ipinfo.io/ip -qO -)
else
    echo -e "\nLeaving from previous Swarm.."
    sudo docker swarm leave -f
    echo -e "\nInitialize Swarm.."
    sudo docker swarm init --advertise-addr=$(wget http://ipinfo.io/ip -qO -)
fi

if [[ $(sudo docker network ls | grep mip-local) == '' ]]; then
    echo -e "\nInitialize Network"
    sudo docker network create \
            --driver=overlay --opt encrypted  --subnet=10.20.30.0/24  --ip-range=10.20.30.0/24 --gateway=10.20.30.254 mip-local
fi

#Get hostname of node
name=$(hostname)

echo -e "\nUpdate label name for Swarm node "$name
sudo docker node update --label-add name=${name} ${name}
echo -e "\n"

while read -r line1 ; do
    read -r line2
    imageName=$(echo "$line1" | cut -d ':' -d ' ' -d '"' -f 2 -d '"')
    tag=$(echo "$line2" | cut -d ':' -d ' ' -d '"' -f 2 -d '"')
done < exareme.yaml

#Remove services if already existed
if [[ $(sudo docker service ls | grep ${name}"_exareme-keystore") != '' ]]; then
    sudo docker service rm ${name}"_exareme-keystore"
fi

if [[ $(sudo docker service ls | grep ${name}"_exareme-master") != '' ]]; then
    sudo docker service rm ${name}"_exareme-master"
fi

env FEDERATION_NODE=${name} FEDERATION_ROLE=${FEDERATION_ROLE} EXAREME_IMAGE=${imageName}":"${tag} \
EXAREME_KEYSTORE=${EXAREME_KEYSTORE} DOCKER_DATA_FOLDER=${DOCKER_DATA_FOLDER} \
LOCAL_DATA_FOLDER=${LOCAL_DATA_FOLDER} \
sudo docker stack deploy -c docker-compose-master.yml ${name}

echo -e "\nDo you wish to run Portainer service? [ y/n ]"
read answer

while true
do
    if [[ ${answer} == "y" ]];then
        if [[ $(sudo docker service ls | grep mip_portainer) != '' ]]; then
            sudo docker service rm mip_portainer
        fi
        . ./portainer.sh
        break
    elif [[ ${answer} == "n" ]]; then
        break
    else
        echo ${answer}" is not a valid answer. Try again [ y/n ]"
        read answer
     fi
done
