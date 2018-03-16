#!/bin/bash
##### Use this script to sort all bedfiles using bedtools

##### submission command
##        bash makeBDG_intersectPeaks.sh $PEAKFILE $BEDFILE $OUTNAME; done
## e.g.:  bash makeBDG_intersectPeaks.sh SLO.union.peaks.bed LS.subSamp2.bed LSxSLO

## add modules
module add ucsc_tools

##### set variables
PEAKFILE=$1
BEDFILE=$2
OUTPREFIX=$3
CHROMSIZES=/srv/gsfs0/projects/snyder/chappell/Annotations/UCSC-hg19/hg19.chrom.sizes

##### write tempscripts for each
cat > $OUTPREFIX.tempscript.sh << EOF
#!/bin/bash
#$ -N $OUTPREFIX.BDGcoverage
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
bedtools intersect -a $OUTPREFIX.hg19.bdg -b $PEAKFILE > $OUTPREFIX.TEMP.bdg

## sort bedgraphs
echo "sorting bedGraphs"
sort -k 1,1 -k2,2n $OUTPREFIX.TEMP.bdg > $OUTPREFIX.avgSigUnionPeaks.bdg
rm $OUTPREFIX.TEMP.bdg 
# rm $OUTPREFIX.hg19.bdg

## create bigwigs from bedgraphs
echo "convert bedGraph to bigWig"
bedGraphToBigWig $OUTPREFIX.hg19.bdg $CHROMSIZES $OUTPREFIX.hg19.bw
bedGraphToBigWig $OUTPREFIX.avgSigUnionPeaks.bdg $CHROMSIZES $OUTPREFIX.avgSigUnionPeaks.bw

## delete bedgraphs
rm $OUTPREFIX.avgSigUnionPeaks.bdg $OUTPREFIX.hg19.bdg

echo "Done!"
EOF

##### bash then remove the tempscript
qsub $OUTPREFIX.tempscript.sh
sleep 1
rm $OUTPREFIX.tempscript.sh
