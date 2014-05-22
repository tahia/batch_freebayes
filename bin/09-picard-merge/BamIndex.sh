#!/bin/bash
#SBATCH -J bam_index
#SBATCH -o bam_index.o%j
#SBATCH -e bam_index.e%j
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -A P.hallii_expression

module load samtools
module load launcher
CMD="bam-index.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD

echo "DONE";
date;
