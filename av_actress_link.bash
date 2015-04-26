#!/bin/bash

dir=$(dirname $0)

## INPUT :: keyword
keyword=$1

## default keyword :: a

[ "$keyword" == ""  ] && {
  keyword="a"
}

## refresh the link_keyword.dat file
[ -e "$dir/dat/av_actress_link_${keyword}.dat" ] && {
  rm "$dir/dat/av_actress_link_${keyword}.dat"
}

## check the max page num 
curl -s -S "http://actress.dmm.co.jp/-/list/=/keyword=${keyword}/page=1/" | nkf -w8 > /tmp/"$keyword"_1.html

pageMax=$(
  cat /tmp/"$keyword"_1.html | 
  grep '全[0-9][0-9]*ページ中' | 
  tr ' ' '\n' | 
  grep '全[0-9][0-9]*ページ中' | 
  sed 's/^全\([0-9][0-9]*\)[^0-9]*/\1/'
)

[ "$pageMax" == "" ] && {
  pageMax="1"
}

echo ""
echo "MAX PAGE NUMBER :: ${pageMax}"
echo ""


for i in `seq 1 $pageMax`; do

  echo "------------------------------"
  echo ""
  echo "NOW DOWNLOADING ::  http://actress.dmm.co.jp/-/list/=/keyword=$keyword/page=$i/" 
  echo ""

  curl -s -S "http://actress.dmm.co.jp/-/list/=/keyword=$keyword/page=$i/" | 
  nkf -w8 > /tmp/${keyword}_${i}.html

  cat /tmp/${keyword}_${i}.html | 
  grep '^<td width="100" nowrap>' | 
  grep actress_id | 
  tr " <>" "\n" | 
  grep "href" | 
  sed 's/^href="\([^"]*\)"/\1/' >> $dir/dat/av_actress_link_${keyword}.dat

  sleep 1
done

