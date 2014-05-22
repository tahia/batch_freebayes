We need vcflib to process freebayes

go to https://github.com/ekg/vcflib

for stampede:
module load git
git clone --recursive https://github.com/ekg/vcflib.git
cd vcflib
make


you will find all executables in bin directory.you need to mention path to this bin directory for JoinFreebayes.sh

To run freebayes parallel you need to split genomes in region using a python script in "script" directory where freebase is installed.

usage:  fasta_generate_regions.py  <fasta index file> <region size>
generates a list of freebayes/bamtools region specifiers on stdout
intended for use in creating cluster jobs

So, it better to decide region size depending on the number of core you are using.

Say, you have a genome of 300M while you hane 256 cores in hand; the region size will be = (300 *1000000)/256 = 1171875 bp ~ 1200000 bp

So the command will be:

python /path/to/freebapes/scripts/fasta_generate_regions.py /path/to/reference/ref.fai 1200000 

it will generate ref.fa.1200000.regions

Now show the /path/to/region/file/ref.fa.1200000.regions as region file option for making param file.

Finally, you can use "vcf_to_joinmap_v3.pl" to generate .loc file for joinmap.
