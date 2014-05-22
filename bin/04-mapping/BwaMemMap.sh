#!/bin/bash
#SBATCH -J full_map
#SBATCH -o full_map.o%j
#SBATCH -e full_map.e%j
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -A P.hallii_expression

module load bwa
module load launcher
CMD="Bwa-File.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD

echo "DONE";
date;
