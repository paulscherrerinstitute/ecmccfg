#!/bin/bash

# File that writes a line of code to an output file and exchanges "€" to "'" "£" to "$", ";" to "|" 
CODELINE=$1
OUTPUT_FILE=$2
OBJ_ID=$3
COMMAND=$4

PREF="ecmcConfigOrDie $4($OBJ_ID,"

echo "$PREF$CODELINE)" | sed "s/€/\'/g" | sed "s/£/$/g" | sed "s/;/|/g"
echo "$PREF$CODELINE)" | sed "s/€/\'/g" | sed "s/£/$/g" | sed "s/;/|/g" >> $OUTPUT_FILE
