#!/bin/bash
# Taslima Haque
# May 07 2014
# make-qr-param.sh - makes parameter file for running the quality control program

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]] | [[ -z $3 ]] | [[ -z $4 ]] | [[ -z $5 ]]; then
    echo "usage: make-dmltplx-param.sh </mplx-fastq-path/> </output-path/> </barcode_file/> </enz_name_1/> </enz_name_2/>" 
    exit 1;
fi

# Declare variables
DIRS=$1
ODIR=$2
BAR=$3
ENZ1=$4
ENZ2=$5
PARAM="dmltplx.param"
LOG="logs/"
SCRIPT="/work/02786/taslima/usr/bin/process_radtags "

# Check if input dir exists
if [[ ! -d $DIRS ]]; then
    echo "ERROR: The input directory $DIRS doesn't exist!!!"
    exit 1;
fi

# Check if output and log dirs exist, if not make them
if [ ! -d $ODIR ]; then
    echo "Output directory doesn't exist. Making $ODIR"
    mkdir $ODIR
fi

if [ ! -d $LOG ]; then 
    echo "Log directory doesn't exist. Making $LOG"
    mkdir $LOG
fi

ENZ1_DIR="${ODIR}${ENZ1}"
if [ ! -d $ENZ1_DIR ]; then
    echo "Output directory doesn't exist. Making $ENZ1_DIR"
    mkdir $ENZ1_DIR
fi

ENZ2_DIR="${ODIR}${ENZ2}"
if [ ! -d $ENZ2_DIR ]; then
    echo "Output directory doesn't exist. Making $ENZ2_DIR"
    mkdir $ENZ2_DIR
fi


# Check if parameter file exists. Remove it and create placeholder
if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

OLOG1=${LOG}${ENZ1}.log
OLOG2=${LOG}${ENZ2}.log
echo "$SCRIPT -p $DIRS -o $ENZ1_DIR -b $BAR --inline_index --renz_1 $ENZ1 -r -c -q > $OLOG1" >> $PARAM
echo "$SCRIPT -p $DIRS -o $ENZ2_DIR -b $BAR --inline_index --renz_1 $ENZ2 -r -c -q > $OLOG2" >> $PARAM

