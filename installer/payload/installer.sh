#!/bin/bash
set -e
echo "Running installer..."


DEFAULT_TARGET=/opt/freeconda
TARGET=$DEFAULT_TARGET

echo -n "Enter target directory [$TARGET]: "
read TARGET

if [ "$TARGET" == "" ]
then
  TARGET=$DEFAULT_TARGET
fi

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

echo "Relocating.."
PLACEHOLDER="/opt/freeconda"
for fixfile in $(grep -rl "$PLACEHOLDER" $TARGET/bin)                                                                
do                                                                                                           
  $TARGET/bin/python relocate.py $PLACEHOLDER $TARGET $fixfile                                                                        
done  


echo "Done"