#!/bin/bash

conv() {
    echo "| ID | ENDEREÇO_DE_REDE | PRIMEIRO_HOST | ÚLTIMO_HOST | BROADCAST |"
    i=1
    while [ $i -le $subnets ];
    do  
        # Encontrando a faixa de hosts
        first_host=$(( $last_net + 1 ))
        last_host=$(( $last_broadcast - 1 ))

        echo "| ${i} | ${split[0]}.${split[1]}.${split[2]}.${last_net} | ${split[0]}.${split[1]}.${split[2]}.${first_host} | ${split[0]}.${split[1]}.${split[2]}.${last_host} | ${split[0]}.${split[1]}.${split[2]}.${last_broadcast} |";   

        # Encontrando os octetos de rede e broadcast
        last_net=$((last_net + hosts))
        last_broadcast=$((last_broadcast + hosts))
        
        i=$(($i+1))
    done
}

find() {
    echo "| ID | ENDEREÇO_DE_REDE | PRIMEIRO_HOST | ÚLTIMO_HOST | BROADCAST |"
    i=1
    while [ $i -le $subnets ];
    do
        first_host=$(( $last_net + 1 ))
        last_host=$(( $last_broadcast - 1 ))
        if [ ${split[3]} -ge $last_net ] && [ ${split[3]} -le $last_broadcast ]; then
            echo "| ${i} | ${split[0]}.${split[1]}.${split[2]}.${last_net} | ${split[0]}.${split[1]}.${split[2]}.${first_host} | ${split[0]}.${split[1]}.${split[2]}.${last_host} | ${split[0]}.${split[1]}.${split[2]}.${last_broadcast} |";   
        fi

        last_net=$((last_net + hosts))
        last_broadcast=$((last_broadcast + hosts))
        
        i=$(($i+1))
    done
}

clear;
echo "----------------------------------------";
echo "--- SubnetDotSh --- Calculadora IPv4 ---";
echo "----- por: <ogabrielpereira@pm.me> -----";
echo "----------------------------------------";
echo "Digite 1 para converter de /24 para /25../32."
echo "Digite 2 para achar apenas as informações do endereço IP informado."
read -p "Opção(Padrão 1): " c
if [ -z $c ]; then
    echo "Opção padrão selecionada."
fi

# IP HANDLING
read -p "Endereço IP: " ip 
split=(${ip//./ }) # Split the IP address into 4 octets
if [ ${#split[*]} -lt 4 ] || [ ${#split[*]} -gt 4 ] ; then
    echo "IP Inválido!"
    exit 1
fi

# SUBNET MASK HANDLING
read -p "Máscara de Sub-rede(CIDR)(Padrão: 24): " mask
if [ -z $mask ]; then
    echo "Máscara padrão selecionada."
    mask=24
fi
if [ $mask -gt 32 ] || [ $mask -lt 24 ]; then
    echo "Mascara de Sub-rede Inválida!"
    exit 1
fi

# CALCULATIONS
hosts=$(( 2**(32-$mask) ))
subnets=$(( 2**($mask-24) ))
last_net=0 
last_broadcast=$((hosts-1))

# OUTPUTS
clear;
echo "Endereço IP: $ip"
echo "Nova Máscara de sub-rede: 255.255.255.$((256-$hosts)) = /$mask"
echo "Número de hosts por sub-rede: $((hosts-2))"
echo "Número de sub-redes: $subnets"

case $c in
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
        echo "Opção inválida, saindo..."
        exit 1
        ;;
esac