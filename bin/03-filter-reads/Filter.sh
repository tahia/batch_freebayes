#!/bin/bash
#SBATCH -J filter_job
#SBATCH -o filter_job.o%j
#SBATCH -e filter_job.e%j
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p development
#SBATCH -t 00:30:00
#SBATCH -A P.hallii_expression

module load launcher
CMD="Filter-File.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD

echo "DONE";
date;
