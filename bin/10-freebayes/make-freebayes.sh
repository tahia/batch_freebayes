
#!/bin/bash
# Taslima haque
# 

if [[ -z $1 ]] | [[ -z $2 ]] | [[ -z $3 ]] | [[ -z $4 ]] ; then
  echo "Usage: make-freebayes.sh in_ref_fasta in_mrg_bam region_file out_file"
  exit 1;
fi

#change the path to executable of freebayes according to your directory
SCRIPT="/work/02786/taslima/usr/bin/freebayes"
RFE_FAS=$1
MRG_BAM=$2
RGN=$3
OFIL=$4
PARAM="freebayes.param"
LOGD="logs/"

declare -i ind
ind=1

if [ ! -f $RFE_FAS ]; then 
	echo "Didn't find any reference file; Usage: make-freebayes.sh in_ref_fasta in_mrg_bam region_file out_file" 
	exit 1; 
fi

if [ ! -f $MRG_BAM ]; then 
	echo "Didn't find any BAM file; Usage: make-freebayes.sh in_ref_fasta in_mrg_bam region_file out_file" 
	exit 1;
fi

if [ ! -f $RGN ]; then
        echo "Didn't find any region file; Usage: make-freebayes.sh in_ref_fasta in_mrg_bam region_file out_file"
        exit 1;
fi

if [ ! -d $LOGD ]; then mkdir $LOGD; fi
if [ -e $PARAM ]; then rm $PARAM; fi
touch $PARAM

	
BASE=$(basename $OFIL)
DIR=$(dirname $OFIL)
NAME=${BASE%.*}
#LOG="${LOGD}${NAME}.log"

for LINE in `cat $RGN`
do
	LOG="${LOGD}${NAME}${ind}.log"
	OUT="${DIR}/${NAME}_split_${ind}.vcf"
	ind=ind+1
	echo "$SCRIPT -r $LINE -f $RFE_FAS -b $MRG_BAM -v $OUT > $LOG" >> $PARAM
done
