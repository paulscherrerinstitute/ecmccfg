#!/bin/sh
PREFIX=$1
M_ID=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-EC-Mst | tr -d '"')
ROWS=$( caget -noname -nostat -nounit -int $PREFIX:MCU-Cfg-UI-EC-Rows | tr -d '"')
start_ecmc_overview.py --master $M_ID --rows $ROWS $PREFIX
