#!/bin/bash

# File that writes a line of code to an output file and exchanges "€" to "'" "£" to "$"
CODELINE=$1
OUTPUT_FILE=$2
STR_TO_REPLACE=$3
DOLLAR_TO_REPLACE=$4
echo "$CODELINE" | sed "s/$STR_TO_REPLACE/\'/g" | sed "s/$DOLLAR_TO_REPLACE/$/g" >> $OUTPUT_FILE
