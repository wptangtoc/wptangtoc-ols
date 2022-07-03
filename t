#!/bin/bash
git rm --cache wptangtoc-ols.zip
seria=$(
      head /dev/urandom | tr -dc 0-9 | head -c 16
      echo ''
)
echo "$seria" > tool-wptangtoc-ols/serie

rm -f wptangtoc-ols.zip
zip -r wptangtoc-ols.zip tool-wptangtoc-ols
