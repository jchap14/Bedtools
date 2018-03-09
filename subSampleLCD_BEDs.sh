#!/bin/bash
##### Generate BED files with equal number of reads in each

##### bash subSampleLCD_BEDs.sh $BEDLIST

## $BEDLIST = a newline separated textfile of BEDs

## define variables
BEDLIST=`echo $1`
NAME=`basename $BEDLIST .BEDlist`

## write a tempscript to be looped over
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.subSampBED
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=1G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

########## Commands
## create an empty file called $NAME.BEDCount
echo "create an empty file called $NAME.BEDCount"
touch $NAME.BEDCount

## count the # of alignments in each BED
echo "count the # of alignments in each BED"
for line in \`cat $BEDLIST\`
do
    wc -l \$line >> $NAME.BEDCount
done

## find the BED with the lowest # & set it as a variable
echo "find the BED with the lowest # & set it as a variable"
MIN=\`cat $NAME.BEDCount | sort -n | head -1\`

## subsample each BED to the MIN # of reads
echo "subsample each BED to the MIN # of reads"
for line in \`cat $BEDLIST\`
do
    NM=\`echo \$line | sed 's:.*/::'\`
    cat \$line | shuf | head -n \$MIN > \$NM.shuf.bed
    echo "sorting \$NM.shuf.bed"
    sort -k 1,1 -k2,2n \$NM.shuf.bed > $NAME.subSamp2.bed
done
##
EOF

## qsub then remove the tempscript
qsub $NAME.tempscript.sh 
sleep 1
rm $NAME.tempscript.sh
