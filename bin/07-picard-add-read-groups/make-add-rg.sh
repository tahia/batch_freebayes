#!/bin/bash
# Kyle Hernandez , modified by TH
# make-add-rg.sh - Author AddOrReplaceReadGroups job

if [[ -z $1 ]] | [[ -z $2 ]] ; then
  echo "Usage make-add-rg.sh in/dir/ out/dir/"
  exit 1;
fi

SCRIPT="\$TACC_PICARD_DIR/AddOrReplaceReadGroups.jar"
INDIR=$1
ODIR=$2
PARAM="Add-grp.param"
LOGD="logs/"

if [ ! -d $ODIR ]; then mkdir $ODIR; fi
if [ ! -d $LOGD ]; then mkdir $LOG; fi
if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

# See how easy it is if you submit meaningful sample IDs to GSAF
# JOB_SAMPLE_BAR_LANE_LIB.....bam
for fil in ${INDIR}*_sorted.bam; do
  BASE=$(basename $fil)
  NAME=${BASE%.*}
  OUT="${ODIR}${NAME}_RG.bam"
  LOG="${LOGD}${NAME}.log"
  # If your filenames contain all the information but are in different orders,
  # you can simply change the values of the '{print $#}' to whatever index after the 
  # split (-F"_" splits on '_'), but remember awk is 1-based index.
  #
  # The GSAF JOB ID we appended to the front
  JOB=`echo $NAME | awk -F"_" '{print $1}'`
  # The SAMPLEID, which should be the 2nd index
  SAMP=`echo $NAME | awk -F"_" '{print $2}'`
  # The BARCODE, which the GSAF should add after the sample ID.
  BAR=`echo $NAME | awk -F"_" '{print $3}'`
  # The LANE, which the GSAF should add after the BAR
  LANE=`echo $NAME | awk -F"_" '{print $4}'`
  # The LIB, which the library ID
  LIB=`echo $NAME | awk -F"_" '{print $5}'`
  # Now you simply add in the variables to the picard command.
  echo -n "java -Xms1G -Xmx1500M -jar $SCRIPT INPUT=$fil OUTPUT=$OUT SORT_ORDER=coordinate " >> $PARAM
  # These are the conventions used
  # -Xmx1500M is maximum for using all 16 cores in stampede
  echo -n "RGID=${JOB}-${LANE} RGLB=$LIB RGPL=illumina RGPU=${JOB}-${LANE}.${BAR} " >> $PARAM
  # RGCN and RGDS aren't required
  # Remember that RGSM is how GATK will find which samples are which, so don't screw this up!
  echo "RGSM=${SAMP} RGCN=UT-GSAF RGDS=$NAME > $LOG" >> $PARAM
done
