#!/bin/bash
#SBATCH -J sam_sort
#SBATCH -o sam_sort.o%j
#SBATCH -e sam_sort.e%j
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -A P.hallii_expression

module load picard
module load launcher
CMD="Sort-SAM.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD

echo "DONE";
date;
