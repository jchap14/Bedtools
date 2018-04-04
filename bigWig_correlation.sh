#!/bin/bash

##### bash bigWig_correlation.sh

## define variables
BIGWIGS=`find *.nmSort.bw | tr '\n' ' '`

## write a tempscript to be looped over
cat > BWcorr.tempscript.sh << EOF
#!/bin/bash
#$ -N $NAME.BWcorr
#$ -j y
#$ -cwd
#$ -V
#$ -l h_vmem=4G
#$ -pe shm 1
#$ -l h_rt=0:59:00
#$ -l s_rt=0:59:00

##### run commands
echo "correlating bigwigs"
wigCorrelate $BIGWIGS > bigWig_correlation.txt
EOF

## qsub then remove the tempscript
bash BWcorr.tempscript.sh 
sleep 1
rm BWcorr.tempscript.sh
