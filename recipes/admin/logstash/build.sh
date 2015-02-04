#!/bin/bash
rm LICENSE README.md
mv bin/plugin bin/plugin-logstash
cp -a * $PREFIX/
