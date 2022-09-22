#!/bin/bash

# IP HANDLING
read -p "IP Address: " ip 
IFS="." 
read -a split <<< "$ip" # Split the IP address into 4 octets

if [ ${#split[*]} -lt 4 ] || [ ${#split[*]} -gt 4 ] ; then
    echo "Invalid IP"
    exit 1
fi

# SUBNET MASK HANDLING
read -p "Subnet Mask(CIDR): " mask
if [ $mask -gt 32 ] || [ $mask -lt 24 ]; then
    echo "Invalid mask"
    exit 1
fi

# CALCULATIONS
hosts=$(( 2**(32-$mask) ))
subnets=$(( 2**($mask-24) ))
last_net=0 
last_broadcast=$((hosts-1))

main() {
    echo "| ID | ENDEREÇO_DE_REDE | PRIMEIRO_HOST | ÚLTIMO_HOST | BROADCAST |"
    i=1
    while [ $i -le $subnets ];
    do
        first_host=$(( $last_net + 1 ))
        last_host=$(( $last_broadcast - 1 ))

        echo "| ${i} | ${split[0]}.${split[1]}.${split[2]}.${last_net} | ${split[0]}.${split[1]}.${split[2]}.${first_host} | ${split[0]}.${split[1]}.${split[2]}.${last_host} | ${split[0]}.${split[1]}.${split[2]}.${last_broadcast} |";   

        last_net=$((last_net + hosts))
        last_broadcast=$((last_broadcast + hosts))
        
        i=$(($i+1))
    done
}

main | column -t