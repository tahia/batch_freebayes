#!/bin/bash
#SBATCH -J picard_merge
#SBATCH -o picard_merge.o%j
#SBATCH -e picard_merge.e%j
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -A P.hallii_expression

module load picard
module load launcher
CMD="merge.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD

echo "DONE";
date;
