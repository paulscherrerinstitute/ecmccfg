#!/bin/bash

# File that writes a line of code to an output file and exchanges "€" to "'"
CODELINE=$1
OUTPUT_FILE=$2
CHR_TO_REPLACE=$3
echo "$CODELINE" | sed "s/$CHR_TO_REPLACE/\'/g" >> $OUTPUT_FILE
