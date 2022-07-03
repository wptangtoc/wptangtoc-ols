#!/bin/bash
git rm --cache wptangtoc-ols.zip
check_seria=$(cat tool-wptangtoc-ols/wptt-update2 | grep 'Seria' | cut -f2 -d ':' | cut -f1 -d '"')
seria=$(
      head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12
      echo ''
)
sed -i "s/$check_seria/$seria/g" tool-wptangtoc-ols/wptt-update2

rm -f wptangtoc-ols.zip
zip -r wptangtoc-ols.zip tool-wptangtoc-ols
