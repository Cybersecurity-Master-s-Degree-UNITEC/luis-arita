set datafile separator ","
set terminal pngcairo size 800,600 enhanced font 'Arial,12'
set output 'ejercicio1.png'
set title "Latencia de Memoria"
set xlabel "Working Set"
set ylabel "Latencia (ns)"
set xrange [0.5:5.5]
set grid
set style data linespoints
set xtics ("4K" 1, "32K" 2, "256K" 3, "8M" 4, "64M" 5)
plot "ejercicio1.csv" using ($0+1):2 skip 1 with linespoints title "Latencia"