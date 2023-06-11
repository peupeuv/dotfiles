#!/bin/bash

echo "Processing X files ...";
echo "Working Directory : [$(pwd)]";

for i in *.csv;
do
        echo -e -n " File: $i \t";
        echo -e -n " nb_non_uft-8_chars: \033[0;31m$(grep -c -axv '.*' $i  )\033[0m \t";
        # echo -e " nb_bad_codes: \033[0;31m$(grep -c '+' $i  )\033[0m";

        nb=$(grep -c -axv '.*' $i);
        iconv -f utf-8 -t utf-8 -c $i > ${i%%.*}_utf-8.csv;
        echo "File: $i --> ${nb} :done";

done
echo "done";
