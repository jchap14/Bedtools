#!/bin/bash
##### Use this script to sort all bedfiles using bedtools

##### submission command
##        bash makeBDG_intersectPeaks.sh $PEAKFILE $BEDFILE $OUTNAME; done
## e.g.:  bash makeBDG_intersectPeaks.sh SLO.union.peaks.bed LS.subSamp2.bed LSxSLO

##### set variables
PEAKFILE=$1
BEDFILE=$2
OUTPREFIX=$3
CHROMSIZES=/srv/gsfs0/projects/snyder/chappell/Annotations/GENCODE-v19-GRCh37-hg19/hg19.chrom.sizes

##### write tempscripts for each
cat > $OUTPREFIX.tempscript.sh << EOF
#!/bin/bash
#$ -N $OUTPREFIX.subSampBED
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=1G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

########## Commands

## run the bedtools genomecov command to calculate the coverage into bedGraph format
echo "run the bedtools genomecov command to calculate the coverage into bedGraph format"
bedtools genomecov -bg -i $BEDFILE -g $CHROMSIZES > $OUTPREFIX.hg19.bdg

## intersect the bedGraph with regions of interest (e.g. peaks)
echo "intersecting bedGraph with regions of interest"
bedtools intersect -a $BEDFILE -b $PEAKFILE > $OUTPREFIX.avgSigUnionPeaks.bdg

echo "Done!"
EOF

##### bash then remove the tempscript
qsub $OUTPREFIX.tempscript.sh
sleep 1
# rm $OUTPREFIX.tempscript.sh
