#!/bin/bash

WIG1="/srv/gsfs0/projects/snyder/chappell/JR/SLO/CUT_n_RUN/2017.10.25/peak_calling/GFP_K27me3.nmSort.bw"
WIG2="/srv/gsfs0/projects/snyder/chappell/JR/SLO/CUT_n_RUN/2017.10.25/peak_calling/MEK5_K27me3.nmSort.bw"
WIG3="/srv/gsfs0/projects/snyder/chappell/JR/SLO/CUT_n_RUN/original_set/GFP__K27me3.nmSort.bw"
WIG4="/srv/gsfs0/projects/snyder/chappell/JR/SLO/CUT_n_RUN/original_set/MEK5_K27me3.nmSort.bw"

wigCorrelate $WIG1 $WIG2 $WIG3 $WIG4 > CnR_bigwig_correlation.txt
