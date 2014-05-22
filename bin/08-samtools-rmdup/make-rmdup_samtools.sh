#!/bin/bash
# Derived from the make-sort script created by Kyle Hernandez
# Altered by TH to remove PCR duplicate by rmdup of samtools

if [[ -z $1 ]] | [[ -z $2 ]]; then
  echo "Usage: make-rmdup_samtools.sh in/dir out/dir"
  exit 1;
fi

SCRIPT="samtools rmdup"
INDIR=$1
ODIR=$2
PARAM="Rmdup.param"
LOG="logs/"

if [ ! -d $LOG ]; then mkdir $LOG; fi

if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

# Loop over the filtered sam files and
# create a sorted sam file. Here I am assuming that the file names end with "Q20.sam".
# You could simply change sam to bam if they are bam files, or change Q20 to something else if you
# used a differen cutoff value.
for fil in ${INDIR}*.bam; do
  BASE=$(basename $fil)
  NAME=${BASE%.*}
  OUT="${ODIR}${NAME}_rmdup.bam"
  OLOG="${LOG}${NAME}.log"
# I kept the same java parameters from the sam sort commands. not sure if they're necessary
  echo "$SCRIPT $fil $OUT > $OLOG " >> $PARAM
done
