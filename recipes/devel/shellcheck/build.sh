#!/bin/bash
cabal install
mkdir -p $PREFIX/bin
cp ~/.cabal/bin/shellcheck $PREFIX/bin
