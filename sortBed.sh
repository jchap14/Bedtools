#!/bin/bash
##### Use this script to sort all bedfiles using bedtools

##### submission command
## for x in `/bin/ls *.bed`; do bash sortBed.sh $x; done

##### set variables
BEDFILE=$1
NAME=`basename $BEDFILE .bed`

##### write tempscripts for each
cat > $NAME.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.bedSort
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 12
#$ -l h_rt=5:59:00
#$ -l s_rt=5:59:00

## run the bedtools sort command
echo "removing quotes & sorting $BEDFILE"
cat $BEDFILE | tr -d '"' | sort -k 1,1 -k2,2n > $NAME.sorted.bed

## change name back to original
# mv $NAME.sorted.bed $NAME.bed
EOF

##### bash then remove the tempscript
qsub $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
