#!/bin/bash
#SBATCH -J add_grp
#SBATCH -o add_grp.o%j
#SBATCH -e add_grp.e%j
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -A P.hallii_expression

module load picard
module load launcher
CMD="Add-grp.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD

echo "DONE";
date;
