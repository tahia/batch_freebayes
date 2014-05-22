#!/bin/bash
#SBATCH -J process_radtags
#SBATCH -o process_radtags.o%j
#SBATCH -e process_radtags.e%j
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -p development
#SBATCH -t 4:0:00
#SBATCH -A P.hallii_expression

module load launcher

CMD="dmltplx.param"

EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CMD
