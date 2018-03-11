#!/bin/bash
##### convert bigwig to bedGraph

# bigWigToBedGraph - Convert from bigWig to bedGraph format.
# usage:
#    bigWigToBedGraph in.bigWig out.bedGraph
# options:
#    -chrom=chr1 - if set restrict output to given chromosome
#    -start=N - if set, restrict output to only that over start
#    -end=N - if set, restict output to only that under end
#    -udcDir=/dir/to/cache - place to put cache for remote bigBed/bigWigs

##### run command
# for x in `/bin/ls *.bigwig` ; do bash bigWigToBedGraph.sh $x; done

## add modules
module add ucsc_tools

## define variables *include CHROM only if subsetting to a particular chromosome
NAME=`basename $1 .bigwig`
GENOME_FILE="/srv/gsfs0/projects/snyder/chappell/Annotations/UCSC-hg19/hg19.chrom.sizes"
CHROM="chr10"
CHROMopt="-chrom=chr10"

##### create tempscript to submit
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.bw2bdg
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 2
#$ -l h_rt=00:59:00
#$ -l s_rt=00:59:00

## run commands
# Sort by read name
bigWigToBedGraph $NAME.bigwig $NAME.$CHROM.bdg $CHROMopt
EOF

## qsub then remove the tempscript
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
