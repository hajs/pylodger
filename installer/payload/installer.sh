#!/bin/bash
set -e
echo "Running installer..."

TARGET=/opt/freeconda

echo -n "Installing to $TARGET? Confirm with 'yes': "
read OK

if [ "$OK" != "yes" ]
then
  echo "Answer was not 'yes'. Aborting"
  exit 2
fi

echo "Extracing..."
mkdir -p $TARGET
tar x -f files.tar -C $TARGET

echo "Done"