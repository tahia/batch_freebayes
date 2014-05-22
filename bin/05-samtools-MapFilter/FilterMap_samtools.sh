#!/bin/bash
#SBATCH -J sam_fltr
#SBATCH -o sam_fltr.o%j
#SBATCH -e sam_fltr.e%j
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -A P.hallii_expression

module load samtools
module load launcher
CMD="FilterMap_samtools.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD

echo "DONE";
date;
