#!/bin/bash

# Duplex: order pages to allow printing double side even if the printer does not allow it
# creates two files to be printed with the pages in the order required

if [ $# -ne 2 ]; then
    echo "Usage: $0 INFILE START_PAGE"
    exit
fi

INFILE=$1
START=$2
TOTAL=$(pdftk "$INFILE" dump_data output|grep -i NumberOfPages|cut -d" " -f2)
ODD=""
EVEN=""

FLAG=1
for i in $(seq $START $TOTAL); do
	if [ "$FLAG" = 1 ]; then
		ODD="$ODD $i"
		FLAG=0
	else	
		EVEN="$i $EVEN"
		FLAG=1
	fi	
done

pdftk A="$INFILE" cat $EVEN output "${INFILE%%.pdf}_one.pdf"
pdftk A="$INFILE" cat $ODD output "${INFILE%%.pdf}_two.pdf"
