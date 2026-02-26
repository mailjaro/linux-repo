#!/usr/bin/bash

for f in [0-9][0-9]-*.md; do
  num=${f:0:2}                            	# Extract '01', '02', etc.
  newnum=$(printf "%02d" $((10#$num + 1)))  	# Increment number
  newname="${newnum}${f:2}"               	# Combine new number with rest of filename
  mv "$f" "$newname"	                 	# Preview; remove 'echo' to rename
done
