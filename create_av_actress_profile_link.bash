#!/bin/bash


## Create list of av-actress profile-link-page url 

dir=$(dirname $0)

for keyword in `cat $dir/keywords.list` 
do
  echo "keyword :: "${keyword}
  ${dir}/av_actress_link.bash ${keyword}
done

