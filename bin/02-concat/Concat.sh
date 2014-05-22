#!/bin/bash
# Taslima Haque Jan, 2014
# make-filter-param.sh - makes parameter file for running the read trim/filter 

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]] | [[ -z $3 ]]; then
    echo "usage: </input_enzyme_1/path/> </input_enzyme_2/path/>  </output-path/>"
    exit 1;
fi

# Declare variables
DIRS_1=$1
DIRS_2=$2
ODIR=$3

if [ ! -d $ODIR ]; then mkdir $ODIR; fi

for fil in ${DIRS_1}*; do
        BASE=$(basename $fil)   	 # file name without the path
        FILE2="${DIRS_2}${BASE}"
	OFIL="${ODIR}${BASE}" 
        cat  $fil $FILE2 > $OFIL
done # exit the directory for loop
