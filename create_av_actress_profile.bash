#!/bin/bash

dir=$(dirname $0)

## refresh
[ -e "$dir/av_actress_profile.dat" ] && {
  rm $dir/av_actress_profile.dat
}

cat $dir/profile_link.dat | head -n 2 |  
while read line 
do
  $dir/actress_scrape.bash $line
done

