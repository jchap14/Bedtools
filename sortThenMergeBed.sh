#!/bin/bash
##### Use this script to sort all bedfiles using bedtools

##### submission command
## bash sortThenMergeBed.sh $BEDLIST

## $BEDLIST = a newline separated textfile of BEDs

##### set variables
BEDLIST=`echo $1`
NAME=`basename $BEDLIST .BEDlist`

##### write tempscripts for each
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.sortMergeBED
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=1G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

## cat the bedfiles
cat `cat $BEDLIST | tr '\n' ' '` > $NAME.catBED
## run the bedtools sort command
echo "removing quotes & sorting $BEDFILE"
cat $NAME.catBED | tr -d '"' | bedtools sort -i stdin > $NAME.sorted.bed
mergeBed -i $NAME.sorted.bed > $NAME.avg.bed
#
EOF

##### bash then remove the tempscript
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
