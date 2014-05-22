#!/bin/bash
# Kyle Hernandez
# Sep 2 2013
# Modified by DLD Sep 26 2013, by TH 
# make-filter-param.sh - makes parameter file for running the read trim/filter 

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]]; then
    echo "usage: make-filter-param.sh </raw-fastq-parent/path/> </output-path/>"
    exit 1;
fi

# Declare variables
DIRS=$1
ODIR=$2
CMD="Filter-File.param"
LOG="logs/"
SCRIPT="java -Xms1G -Xmx1500M -jar /work/02786/taslima/tools/scalaNGS/target/scala-2.10/NGStools.jar -T FilterReads -P SE_illumina"
#Xmx1500M is the maximum for Sampede used while using all 16 cores
if [ ! -d $ODIR ]; then mkdir $ODIR; fi
if [ ! -d $LOG ]; then mkdir $LOG; fi
if [ -e $CMD ]; then rm $CMD; fi
touch $CMD

# Loop through directories in parent directory
for dir in ${DIRS}*; do
    # Since we have named the directory the JOB ID
    # we extract it like so
    JOB=$(basename $dir)

    # Now we loop through each fastq file in the current 
    # Job directory. Note that ${dir} here is coming from
    # the dir in the for loop above
    for fil in ${dir}/*; do
        BASE=$(basename $fil)   	 # file name without the path
        NAME=${BASE%.fq*} 	 # file name without .fastq.gz
        OFIL="${ODIR}${NAME}.fq" # output file name. Add JOB ID to front
        OLOG="${LOG}${NAME}.log"	 # output log file for this fastq file

	# Now we append to the command/parameter file
        # Use the -n flag for echo to not automatically add a new line
        # to the end of the echo command so we won't have to have a really long
     	# line in this file
	#-START tells the script how much to cut off the beginning of the sequence. This assumes we're working with Read 1
	#We want to cut off the NNMW bit of the RNA oligo, the 3 Gs that follow, and the 8th position which is lots of Gs as well
        echo  -n "$SCRIPT -I $fil -O $OFIL -QV-OFFSET 33 -START 1 " >> $CMD
        echo "-END 100 -HPOLY 0.20 -MINQ 20 -NMISSING 5 > $OLOG" >> $CMD
    done # exit the file for loop
done # exit the directory for loop
