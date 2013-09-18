#!/bin/bash
set -e
echo "Running installer..."

test -f motd.txt && cat motd.txt


DEFAULT_TARGET="$1"
if [ "$DEFAULT_TARGET" == "" ]
then
  DEFAULT_TARGET=$HOME/pylodger
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

if [ -d $TARGET ]
then
  echo "Target directory already exists. Aborting"
  exit 3
fi


echo "Extracing..."
mkdir -p $TARGET
tar x -f files.tar -C $TARGET

echo "Relocating.."
PLACEHOLDER="/opt/pylodger"
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
   #- http://somehost/conda/
   - file:///$TARGET/conda-bld/


" > $RCFILE
cat $RCFILE

echo "You could at $TARGET/bin to your path:"
echo "  export PATH=$TARGET/bin:\$PATH:"

echo "Done"