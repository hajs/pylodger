#!/usr/bin/env python
# -*- coding: utf-8 -*-
"search/replace in-place"
import sys
old, new = sys.argv[1], sys.argv[2]
for filename in sys.argv[3:]:
	data = open(filename).read()
	data = data.replace(old, new)
	open(filename, 'w').write(data)
