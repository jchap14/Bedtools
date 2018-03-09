

#!/bin/bash
##### Use this script to sort all bedfiles using bedtools

##### submission command
##        bash makeBDG_intersectPeaks.sh $PEAKFILE $BEDFILE; done
## e.g.:  bash makeBDG_intersectPeaks.sh SLO.union.peaks.bed 

##### set variables
PEAKFILE=$1
BEDFILE=$2
NAME=`basename $BEDFILE .bed`
CHROMSIZES=/srv/gsfs0/projects/snyder/chappell/Annotations/GENCODE-v19-GRCh37-hg19/hg19.chrom.sizes

##### write tempscripts for each
cat > $NAME.tempscript.sh << EOF
#!/bin/bash

## run the bedtools genomecov command to calculate the coverage into bedGraph format
echo "run the bedtools genomecov command to calculate the coverage into bedGraph format"
bedtools genomecov -bg -i $BEDFILE -g $CHROMSIZES > $NAME.bdg

## run the bedtools sort command
echo "removing quotes & sorting $BEDFILE"
bedtools intersect -a $BEDFILE -b $PEAKFILE


EOF

##### bash then remove the tempscript
bash $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
