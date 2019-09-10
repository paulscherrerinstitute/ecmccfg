#!/usr/bin/env bash

function backup {
  echo "backup of $1 file.."
  cp $1 tmp
}

function desc {
  DESC=`grep '# Description:' $1 | sed 's/\#\ Description:\s*//'`
}

function header {
  hardware=${1##ecmc}
  printf '#-d /**\n' >> $1.tmp
  printf '#-d   \\brief hardware script for %s\n' "${hardware%%.cmd}" >> $1.tmp
  printf '#-d   \\details %s\n' "${DESC}" >> $1.tmp
  printf '#-d   \\author Anders Sandstroem\n' >> $1.tmp
  printf '#-d   \\file\n' >> $1.tmp
}

function reset {
  #statements
  #grep 1684107116 $1 || printf 'No match found for pattern "%s"\n' "$1"
  if grep -q 1684107116 $1; then
    printf '#-d   \\note SDOS\n' >> $1.tmp
    printf '#-d   \\param [out] SDO 0x1011:01 --> 1684107116 \\b reset\n' >> $1.tmp
  else
    echo 'No reset.'
  fi
}

function footer {
  printf '#-d */\n\n' >> $1.tmp
}

function attachOrg {
  cat tmp >> $1.tmp
}

function replaceOrg {
  mv -f $1.tmp $1
}

for f in *.cmd; do
  backup $f
  unset DESC
  desc $f
  header $f
  reset $f
  footer $f
  attachOrg $f
  replaceOrg $f
  rm tmp
done
