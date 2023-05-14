#!/bin/bash

# Make pipeline return code the last non-zero one or zero if all the commands return zero.
set -o pipefail

## \file
## \TODO This file implements a very trivial feature extraction; use it as a template for other front ends.
## 
## Please, read SPTK documentation and some papers in order to implement more advanced front ends.
#DONE

# Base name for temporary files
base=/tmp/$(basename $0).$$ 

# Ensure cleanup of temporary files on exit
trap cleanup EXIT
cleanup() {
   \rm -f $base.*
}

if [[ $# != 4 ]]; then
   echo "$0 lpc_order coef_cepstrum input.wav output.lpcc "
   exit 1
fi

lpc_order=$1
coef_cepstrum=$2 #Segon parametre= coeficient cepstrum
inputfile=$3
outputfile=$4

UBUNTU_SPTK=0
if [[ $UBUNTU_SPTK == 1 ]]; then
   # In case you install SPTK using debian package (apt-get)
   X2X="sptk x2x"
   FRAME="sptk frame"
   WINDOW="sptk window"
   LPCC="sptk lpc2c" #cepstrum coefs
   LPC="sptk lpc"
else
   # or install SPTK building it from its source
   X2X="x2x"
   FRAME="frame"
   WINDOW="window"
   LPCC="lpc2c" #cepstrum coefs
   LPC="lpc"
fi

# Main command for feature extraction
#mateixa ordre, canviem el orden de LPC pel cepstrum i també l'extensió de l'arxiu temporal
#ara queden guardats a $base.lpcc 
sox $inputfile -t raw -e signed -b 16 - | $X2X +sf | $FRAME -l 240 -p 80 | $WINDOW -l 240 -L 240 |
	$LPC -l 240 -m $lpc_order | $LPCC -m $lpc_order -M $coef_cepstrum> $base.lpcc || exit 1
   

# Our array files need a header with the number of cols and rows:
ncol=$((coef_cepstrum+1)) # cepstrum p =>  (gain a1 a2 ... ap) 
nrow=`$X2X +fa < $base.lpcc | wc -l | perl -ne 'print $_/'$ncol', "\n";'`

# Build fmatrix file by placing nrow and ncol in front, and the data after them
echo $nrow $ncol | $X2X +aI > $outputfile
cat $base.lpcc >> $outputfile

exit