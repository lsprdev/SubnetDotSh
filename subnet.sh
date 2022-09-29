#!/bin/bash
DARKGRAY='\033[1;30m'
RED='\033[1;31m'    
GREEN='\033[1;32m'    
YELLOW='\033[1;33m'
BLUE='\033[1;34m'    
CYAN='\033[1;36m'    
WHITE='\033[1;37m'
SET='\033[0m'

conv() {
    echo -e "${GREEN}| ID | ENDEREÇO_DE_REDE | PRIMEIRO_HOST | ÚLTIMO_HOST | BROADCAST |${SET}"
    i=1
    while [ $i -le $subnets ];
    do  
        # Encontrando a faixa de hosts
        first_host=$(( $last_net + 1 ))
        last_host=$(( $last_broadcast - 1 ))

        echo -e "${GREEN}|${SET} ${i} ${GREEN}|${SET} ${split[0]}.${split[1]}.${split[2]}.${last_net} ${GREEN}|${SET} ${split[0]}.${split[1]}.${split[2]}.${first_host} ${GREEN}|${SET} ${split[0]}.${split[1]}.${split[2]}.${last_host} ${GREEN}|${SET} ${split[0]}.${split[1]}.${split[2]}.${last_broadcast} ${GREEN}|${SET}";   

        # Encontrando os octetos de rede e broadcast
        last_net=$((last_net + hosts))
        last_broadcast=$((last_broadcast + hosts))
        
        i=$(($i+1))
    done
}

find() {
    echo -e "${GREEN}| ID | ENDEREÇO_DE_REDE | PRIMEIRO_HOST | ÚLTIMO_HOST | BROADCAST |${SET}"
    i=1
    while [ $i -le $subnets ];
    do
        first_host=$(( $last_net + 1 ))
        last_host=$(( $last_broadcast - 1 ))
        if [ ${split[3]} -ge $last_net ] && [ ${split[3]} -le $last_broadcast ]; then
            echo -e "${GREEN}|${SET} ${i} ${GREEN}|${SET} ${split[0]}.${split[1]}.${split[2]}.${last_net} ${GREEN}|${SET} ${split[0]}.${split[1]}.${split[2]}.${first_host} ${GREEN}|${SET} ${split[0]}.${split[1]}.${split[2]}.${last_host} ${GREEN}|${SET} ${split[0]}.${split[1]}.${split[2]}.${last_broadcast} ${GREEN}|${SET}";   
        fi

        last_net=$((last_net + hosts))
        last_broadcast=$((last_broadcast + hosts))
        
        i=$(($i+1))
    done
}

clear;
echo -e "${GREEN}----------------------------------------${SET}";
echo -e "${GREEN}--- ${WHITE}SubnetDotSh${SET} ${GREEN}---${SET} ${WHITE}Calculadora IPv4${SET} ---${SET}";
echo -e "${GREEN}----- por: <ogabrielpereira@pm.me> -----${SET}";
echo -e "${GREEN}----------------------------------------${SET}";
echo -e "${CYAN}Digite${SET} ${DARKGRAY}1${SET} ${CYAN}para converter de /24 para /25../32.${SET}";
echo -e "${CYAN}Digite${SET} ${DARKGRAY}2${SET} ${CYAN}para achar apenas as informações do endereço IP informado.${SET}";
echo -e "Opção(Padrão 1): \c" && read -n 1 option && echo "";
if [ -z $option ]; then
    echo -e "${YELLOW}Opção padrão selecionada.${SET}";
fi

# IP HANDLING
read -p "Endereço IP: " ip 
split=(${ip//./ }) # Split the IP address into 4 octets
if [ ${#split[*]} -lt 4 ] || [ ${#split[*]} -gt 4 ] ; then
    echo -e "${RED}IP Inválido!${SET}"
    exit 1
fi
if [ ${split[0]} -gt 255 ] || [ ${split[1]} -gt 255 ] || [ ${split[2]} -gt 255 ] || [ ${split[3]} -gt 255 ]; then
    echo -e "${RED}IP Inválido!${SET}"
    exit 1
fi

# SUBNET MASK HANDLING
read -p "Máscara de Sub-rede(CIDR)(Padrão: 24): " mask
if [ -z $mask ]; then
    echo -e "${YELLOW}Máscara padrão selecionada.${SET}"
    mask=24
fi
if [ $mask -gt 32 ] || [ $mask -lt 24 ]; then
    echo -e "${RED}Mascara de Sub-rede Inválida!${SET}"
    exit 1
fi

# CALCULATIONS
hosts=$(( 2**(32-$mask) ))
subnets=$(( 2**($mask-24) ))
last_net=0 
last_broadcast=$((hosts-1))

# OUTPUTS
clear;
echo -e "${BLUE}Endereço IP:${SET} ${DARKGRAY}$ip${SET}"
echo -e "${BLUE}Nova Máscara de sub-rede:${SET} ${DARKGRAY}255.255.255.$((256-$hosts)) = /$mask ${SET}"
echo -e "${BLUE}Número de hosts por sub-rede:${SET} ${DARKGRAY}$((hosts-2)) ${SET}"
echo -e "${BLUE}Número de sub-redes:${SET} ${DARKGRAY}$subnets ${SET}"

case $option in
    1)
        conv | column -t
        ;;
    2)
        find | column -t
        ;;
    n|"")
        conv | column -t
        ;;
    *)
        echo -e "${RED}Opção inválida, saindo...${SET}"
        exit 1
        ;;
esac