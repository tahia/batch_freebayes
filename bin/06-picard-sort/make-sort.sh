#!/bin/bash
# Kyle Hernandez
# Altered by DLD 10.7.13
# make-sort.sh - Author the parameter file for sorting Sam/Bam files with picard

if [[ -z $1 ]] | [[ -z $2 ]]; then
  echo "Usage make-sort.sh in/dir out/dir"
  exit 1;
fi

# DD- The backslash in front of the PICARD TACC invocation in the script line tells bash that the dollar symbol is actually the text, not a variable

SCRIPT="\$TACC_PICARD_DIR/SortSam.jar"
INDIR=$1
ODIR=$2
PARAM="Sort-SAM.param"
LOG="logs/"

if [ ! -d $LOG ]; then mkdir $LOG; fi

if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

# Loop over the filtered sam/bam files and
# create a sorted sam file. Here I am assuming that the file names end with "Q20.sam".
# You could simply change sam to bam if they are bam files, or change Q20 to something else if you
# used a differen cutoff value.
for fil in ${INDIR}*_Q20.bam; do
  BASE=$(basename $fil)
  NAME=${BASE%.*}
  OUT="${ODIR}${NAME}_sorted.bam"
  OLOG="${LOG}${NAME}.log"
  # We choose SORT_ORDER=coordinate because that's what GATK expects. This is the
  # only sorting option performed by samtools. Note that useing -Xmx1500M will allow users of stampede to use all 16 cores.
  
  echo -n "java -Xmx1500M -jar $SCRIPT INPUT=$fil OUTPUT=$OUT SORT_ORDER=coordinate " >> $PARAM
  # setting MAX_RECORD_IN_RAM can help with memory errors. See Picard http://picard.sourceforge.net/
  echo "MAX_RECORDS_IN_RAM=250000 > $OLOG" >> $PARAM
done
