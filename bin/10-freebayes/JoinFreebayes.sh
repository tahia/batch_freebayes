#!/bin/bash
# Taslima Haque
# JoinFreebayes.sh: join and sort VCF files 

# Check for required arguments
if [[ -z $1 ]] | [[ -z $2 ]] | [[ -z $3 ]]; then
    echo "usage: <input_files_dir> <output_file_path> <vcflib_bin_dir>"
    exit 1;
fi

# Declare variables
INDIR=$1
OFIL=$2
VCFLIB=$3

INFILES="${INDIR}*.vcf"
VCFSTRMSORT="${VCFLIB}vcfstreamsort"
VCFUNQ="${VCFLIB}vcfuniq"


`cat $INFILES | grep -v '^##'| $VCFSTRMSORT -w 1000 | $VCFUNQ >$OFIL`
