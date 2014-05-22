
#!/bin/bash
# Kyle Hernandez
# Aug 29 2013
# modified by DD Oct 2 2013, by TH
# make-map-param.sh - makes parameter file for mapping using BWA MEM 

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]] | [[ -z $3 ]]; then
    echo "usage: make-qr-param.sh </filtered-fastq-path/> </output-path/> <reference.genome>"
    exit 1;
fi

# Declare variables
DIRS=$1
ODIR=$2
REF=$3
PARAM="Bwa-File.param"
# This would be the path to your locally installed bwa
#SCRIPT="/home1/01832/kmhernan/bin/bwa-0.7.4/bwa mem"

# If you instead will use module load bwa in your job file then do this
SCRIPT="bwa mem"

if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

# For most cases where you have your filtered/trimmed reads in one directory like
# /data/filtered-reads/
for fil in ${DIRS}*; do
    BASE=$(basename $fil)
    NAME=${BASE%.fq}
    OFIL="${ODIR}${NAME}.sam"
    # -M and -a should be used. See bwa mem README 
    echo "$SCRIPT -t 4 -a $REF $fil > $OFIL" >> $PARAM 
done



