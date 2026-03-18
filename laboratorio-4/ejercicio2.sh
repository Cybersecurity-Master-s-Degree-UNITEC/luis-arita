#!/bin/bash
declare -a array
for ((i=0; i<1000000; i++)); do
    array[i]=$i
done

inicio=$(date +%s%N)
for ((i=0; i<${#array[@]}; i++)); do
    #NOTA: Esta línea no se ocupa para acceder a los elementos del array
    #      Se deja para que el tiempo de ejecución sea similar al del acceso aleatorio
    index=$((RANDOM % ${#array[@]})) 
    array[i]=$((array[i]+1))
done
finalizacion=$(date +%s%N)
tiempo=$(( (finalizacion - inicio) / 1000000 ))
echo "Acceso secuencial: tiempo de ejecución: $tiempo milisegundos"

declare -a array
for ((i=0; i<1000000; i++)); do
    array[i]=$i
done

inicio=$(date +%s%N)
for ((i=0; i<${#array[@]}; i++)); do
    index=$((RANDOM % ${#array[@]}))
    array[index]=$((array[index]+1))
done
finalizacion=$(date +%s%N)
tiempo=$(( (finalizacion - inicio) / 1000000 ))
echo "Acceso aleatorio: tiempo de ejecución: $tiempo milisegundos"

