##########################################################################################
########## Goal is to get average signal (RPM) tracks given several reps per condition ###

##### merge several bigwigs into an average track using bigWigMerge
## Note: The signal values are just added together to merge them
bigWigMerge \
A_F2.1.trim.PE2SE.nodup.tn5.pf.fc.signal.bigwig \
B_F1.1.trim.PE2SE.nodup.tn5.pf.fc.signal.bigwig \
B_F2.1.trim.PE2SE.nodup.tn5.pf.fc.signal.bigwig \
L2.R1.trim.PE2SE.nodup.tn5.pf.fc.signal.bigwig \
1701.LSS.avg_signal.bedGraph
# A_F1.fc.signal.bw \ <- not included to make tracks more even

bigWigMerge \
A_S2.1.trim.PE2SE.nodup.tn5.pf.fc.signal.bigwig \
B_S1.1.trim.PE2SE.nodup.tn5.pf.fc.signal.bigwig \
B_S2.1.trim.PE2SE.nodup.tn5.pf.fc.signal.bigwig \
S2.R1.trim.PE2SE.nodup.tn5.pf.fc.signal.bigwig \
1701.ST.avg_signal.bedGraph

##### sort the bedGraphs & convert back to bigwigs
for i in *.bedGraph
do
name=`basename $i .bedGraph`
sort -k 1,1 -k2,2n $name.bedGraph > $name.bedGraph.sorted
bedGraphToBigWig $name.bedGraph.sorted hg19.chrom.sizes $name.bw
done

########################################################################################
##### use to isolate signal track from a specified chromosome (minimize disk storage)
for i in *.signal.bw
do
name=`basename $i .fc.signal.bw`
chrom=chr1 #specify chromosome of interest here
bigWigToBedGraph $i $name.$chrom.bedGraph -chrom=$chrom
#bedGraphToBigWig $name.$chrom.bedGraph hg19.chrom.sizes $name.$chrom.bigwig
#rm $name.$chrom.bedGraph
done

########################################################################################
##### bigWigSummary: calculates the average signal per base over specified region
bigWigSummary file.bigWig
