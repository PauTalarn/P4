

#!/bin/bash

# Definir los argumentos
x=2
y=3
color1="blue"
color2="blue"
gmm_file="work/gmm/lp/SES117.gmm"
file_pattern="work/lp/BLOCK11/SES117/SA117S*"

# Llamar al script plot_gmm_feat con los argumentos especificados
./Users/pituscastanervila/PAV/P4/scripts/plot_gmm_feat -x $x -y $y -g $color1 -f $color2 $gmm_file $file_pattern
