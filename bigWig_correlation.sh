#!/bin/bash

##### bash bigWig_correlation.sh

wigCorrelate `find *.nmSort.bw | tr '\n' ' '` > bigWig_correlation.txt
