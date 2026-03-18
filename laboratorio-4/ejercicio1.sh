#!/bin/bash
# Hace benchmark de latencia de memoria utilizando lat_mem_rd
# Corre 4 Working sets differentes de 4K, 32K, 256K, 8M y 64M
# Corre 3 veces cada prueba y utiliza el promedio
# Graba los resultados a un CSV
# Imprime el CSV como una tabla
# Genera un PNG para ver los resultados graficados

TMP=$(mktemp)
DATOS="ejercicio1.csv"

# Inicializar CSV
echo "WorkingSet,Latency_ns" > "$DATOS"

# Definir los working sets que buscamos en MB que es lo que acepta lat_mem_rd
S4K=0.00391
S32K=0.03125
S256K=0.25000
S8M=8
S64M=64

for set in "$S4K" "$S32K" "$S256K" "$S8M" "$S64M"; do
    echo "Buscando set de $set"
    suma=0

    SIZEMB=$(awk -v s="$set" 'BEGIN{if(s<1) print 1; else print s}')
    for i in {1..3}; do
        echo "Corrida $i buscando $set con tamano $SIZEMB"
        #Corro el comando del ejercicio y lo guardo en un archivo temporal
        /usr/lib/lmbench/bin/x86_64-linux-gnu/lat_mem_rd $SIZEMB &> "$TMP"  2>&1
        #Recupero todas las lineas que terminan en numeros, me quedo solo con la ultima, agarro la segunda columna
        latencia=$(grep -E "^$set" "$TMP" | head -n1 | awk '{print $2}')
        #acumulo en suma
        suma=$(echo "$suma + $latencia" | bc -l)
    done

    #Calcular el promedio de las tres corridas
    promedio=$(echo "scale=2; $suma / 3" | bc -l)
    # Agregar al CSV
    etiqueta=$(awk -v m="$set" 'BEGIN {if(m<1) printf "%.0fK", m*1024; else printf "%.0fM", m}')
    echo "$etiqueta,$promedio" >> "$DATOS"
done

#Borrar el archivo temporal
rm $TMP

IFS=',' read -r header1 header2 < "$DATOS"
printf "%-12s %-15s\n" "$header1" "$header2"
printf "%-12s %-15s\n" "------------" "---------------"

# Leer cada línea del CSV e imprimir como tabla
tail -n +2 "$DATOS" | while IFS=',' read -r set promedio; do
    printf "%-12s %-15s\n" "$set" "$promedio"
done

gnuplot ejercicio1.gp
xdg-open ejercicio1.png