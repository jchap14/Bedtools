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
## cat the bedfiles
cat `cat $BEDLIST | tr '\n' ' '` > $NAME.catBED
## run the bedtools sort command
echo "removing quotes & sorting $BEDFILE"
cat $NAME.catBED | tr -d '"' | bedtools sort -i stdin > $NAME.sorted.bed
mergeBed -i $NAME.sorted.bed > $NAME.avg.bed
#
EOF

##### bash then remove the tempscript
bash $NAME.tempscript.sh
sleep 1
rm $NAME.tempscript.sh
