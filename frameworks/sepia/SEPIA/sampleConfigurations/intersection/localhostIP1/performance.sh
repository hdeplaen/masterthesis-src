#!/bin/sh

# this script was automatically generated, change it if needed

# we use our custom .toprc so, first try to backup the existing
mv ~/.toprc ~/.toprc_old 
cp ../.toprc ~/.toprc 

# start top in batch mode and keep running until killed
top -b -U $(whoami) -d 10 > $(hostname)perf.log 
