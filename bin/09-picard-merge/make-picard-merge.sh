
#!/bin/bash
# Kyle Hernandez , modified by TH
# 

if [[ -z $1 ]] | [[ -z $2 ]] | [[ -z $3 ]]; then
  echo "Usage make-picard-merge.sh in/dir/ out/dir/ out/file"
  exit 1;
fi

SCRIPT="\$TACC_PICARD_DIR/MergeSamFiles.jar"
SCRIPT_IND="samtools index"
INDIR=$1
ODIR=$2
OFIL=$3
PARAM="merge.param"
PARAM_IND="bam-index.param"
LOGD="logs/"
PREF="INPUT="
IN=""
OUT="${ODIR}${OFIL}.bam"
OUT_IND="${ODIR}${OFIL}.bai"

if [ ! -d $ODIR ]; then mkdir $ODIR; fi
if [ ! -d $LOGD ]; then mkdir $LOG; fi
if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM
if [ -e $PARAM_IND ]; then rm $PARAM_IND; fi
touch $PARAM_IND


for fil in ${INDIR}*_rmdup.bam; do
  BASE=$(basename $fil)
  NAME=${BASE%.*}
  IN+="${PREF}${INDIR}${BASE} "
  #OUT="${ODIR}${NAME}_RG.sam"
  #LOG="${LOGD}${NAME}.log"

done  
LOG="${LOGD}${OFIL}.log"
echo "java -Xms1G -Xmx24G -jar $SCRIPT $IN OUTPUT=$OUT SORT_ORDER=coordinate ASSUME_SORTED=true > $LOG" >> $PARAM
  # -Xmx1500M is maximum for using all 16 cores in stampede
LOG_IND="${LOGD}${OFIL}_IND.log"
echo "$SCRIPT_IND $OUT $OUT_IND > $LOG_IND" >> $PARAM_IND
