#!/bin/bash
#SBATCH -J rmdup
#SBATCH -o rmdup.o%j
#SBATCH -e rmdup.e%j
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -A P.hallii_expression

module load samtools
module load launcher
CMD="Rmdup.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD

echo "DONE";
date;
