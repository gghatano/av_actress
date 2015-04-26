#!/bin/bash

dir=$(dirname $0)

## url
link=$1
linkExistFlg="TRUE"

## default url link
[ "$link" == "" ] && {
  link=$(
    echo "http://actress.dmm.co.jp/-/detail/=/actress_id=11239/"
  )
  linkExistFlg="FALSE";
}

## link check
echo $link

## actres_id
actress_id=$(
  echo $link | 
  awk -F"/" '{print $7}' | 
  cut -d"=" -f2
)


## download
[ "$linkExistFlg" == "TRUE" ] &&{
  curl $link | nkf -w8 > /tmp/actress_id_"$actress_id".html
}

actress_name=$(
  cat /tmp/actress_id_"$actress_id".html | 
  grep "title" | 
  head -n 1 | 
  awk -F"[<>\(\)]" '{print $3}' |
  sed 's/,/、/g' 
)


## extract profile_data
actress_name_yomi=$(
  cat /tmp/actress_id_"$actress_id".html | 
  grep "title" | 
  head -n 1 | 
  awk -F"[<>\(\)]" '{print $4}' |
  sed 's/,/、/g' 
)

birthday=$(
  cat /tmp/actress_id_"$actress_id".html | 
  grep -A1 '^<td align="right" nowrap>' | 
  grep -A1 "生年月日" | 
  tail -n 1 | 
  awk -F"[<>]" '{print $3}' |
  sed 's/,/、/g' 
)

star=$(
  cat /tmp/actress_id_"$actress_id".html | 
  grep -A1 '^<td align="right" nowrap>' | 
  grep -A1 "星座" | 
  tail -n 1 | 
  awk -F"[<>]" '{print $3}' | 
  sed 's/,/、/g'
)

blood=$(
  cat /tmp/actress_id_"$actress_id".html | 
  grep -A1 '^<td align="right" nowrap>' | 
  grep -A1 "血液型" | 
  tail -n 1 | 
  awk -F"[<>]" '{print $3}' | 
  sed 's/,/、/g'
)

style=$(
  cat /tmp/actress_id_"$actress_id".html | 
  grep -A1 '^<td align="right" nowrap>' | 
  grep -A1 "サイズ" | 
  tail -n 1 | 
  awk -F"[<>]" '{print $3}' |
  sed 's/,/、/g'
)

birthPlace=$(
  cat /tmp/actress_id_"$actress_id".html | 
  grep -A1 '^<td align="right" nowrap>' | 
  grep -A1 "出身地" | 
  tail -n 1 | 
  awk -F"[<>]" '{print $3}' | 
  sed 's/,/、/g'
)

special=$(
  cat /tmp/actress_id_"$actress_id".html | 
  grep -A1 '^<td align="right" nowrap>' | 
  grep -A1 "趣味" | 
  tail -n 1 | 
  awk -F"[<>]" '{print $3}' | 
  sed 's/,/、/g'
)

echo $actress_id,$actress_name,$actress_name_yomi,$birthday,$star,$blood,$style,$birthPlace,$special >> av_actress_profile.dat

cat av_actress_profile.dat


