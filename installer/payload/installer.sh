#!/bin/bash
set -e
echo "Running installer..."

DEFAULT_TARGET="$1"
if [ "$DEFAULT_TARGET" == "" ]
then
  DEFAULT_TARGET=/opt/freeconda
fi

if [ "$2" == "force" ]
then
  TARGET=$DEFAULT_TARGET
  
else
  echo -n "Enter target directory [$DEFAULT_TARGET]: "
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


if [ -f "$HOME/.condarc" ]
then
  RCFILE="$HOME/.condarc.new"
else
  RCFILE="$HOME/.condarc"
fi

echo "Writing $RCFILE:"
echo "
binstar_upload: false

channels:
   - http://conda:8787
   # - file:///$TARGET/conda-bld/
" > $RCFILE
cat $RCFILE


echo "Done"