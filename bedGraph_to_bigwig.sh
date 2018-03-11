#!/bin/bash
##### convert bedGraph to bigwig

# for x in `/bin/ls *.bdg` ; do bash bedGraph_to_bigwig.sh $x; done

## add modules
module add ucsc_tools

## define variables
NAME=`basename $1 .bdg`
CHROMSIZES=/srv/gsfs0/projects/snyder/chappell/Annotations/UCSC-hg19/hg19.chrom.sizes

cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.bdg2bw
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 2
#$ -l h_rt=00:59:00
#$ -l s_rt=00:59:00

## run commands
# convert bedGraph to bigWig
echo "convert bedGraph to bigWig"
bedGraphToBigWig $NAME.bdg $CHROMSIZES $NAME.bw

echo "Done!"

EOF

## qsub then remove the tempscript
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
