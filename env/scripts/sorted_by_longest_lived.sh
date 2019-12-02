#!/usr/bin/env bash

awk -F"," '{ if (NR > 1) { print $7 - $6, $0; } }' | sort -nr | awk '{ s=""; for (i = 2; i <= NF; i++) s = s $i " "; print s; }'
