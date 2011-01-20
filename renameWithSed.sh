#!/bin/sh

if [ $# -lt 3 ]; then
  echo "usage: rename_sed.sh regexp replace files..."
  exit 1
fi

regexp="$1"
pattern="$2"
shift 2

for orig do
  new=`echo "$orig" | sed s/"$regexp"/"$pattern"/`
  echo "$orig -> $new"
  mv "$orig" "$new"
done

### EXAMPLE ###
# $ echo hogehoge.txt | sed 's/\(.*\)/\1.csv/g'
# => hogehoge.txt.csv
