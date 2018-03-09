#!/bin/bash
##### Use this script to cat together & then sort specified bedfiles

##### submission command
## bash catThenSortBedfiles.sh $BEDLIST

## $BEDLIST = a newline separated textfile of BEDs

##### set variables
BEDLIST=`echo $1`
NAME=`basename $BEDLIST .BEDlist`

##### write tempscripts for each
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.catSortBED
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

## cat the bedfiles
cat `cat $BEDLIST | tr '\n' ' '` > $NAME.catBED
## run the bedtools sort command
echo "removing quotes & sorting $BEDFILE"
cat $NAME.catBED | tr -d '"' > $NAME.noQuote.bed
echo "removing quotes from bedfile"
cat $NAME.noQuote.bed | grep -v "chrM" > $NAME.noM.bed
echo "sorting bedfil"
sort -k 1,1 -k2,2n $NAME.noM.bed > $NAME.sorted.bed
# echo "merging $BEDFILE"
# mergeBed -s -i $NAME.sorted.bed > $NAME.avg.bed
echo "Done!"
#
EOF

##### bash then remove the tempscript
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
