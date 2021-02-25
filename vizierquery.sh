#!/bin/bash

#user--Adrihp06


centerra=$(astfits -h0 $2 --skycoverage | grep "Center:" | awk '{print $2}')
centerde=$(astfits -h0 $2 --skycoverage | grep "Center:" | awk '{print $3}')
rad=$(astfits -h0 $2 --skycoverage | grep "Width:" | awk '{print $2}')



if [ -f "catalogs.txt" ]; then
    echo "catalogs.txt exists."
else
    curl -ocatalogs.txt --form -c="$centerra $centerde" --form -c.rm="$rad" --form -ucd=$1 "http://vizier.unistra.fr/viz-bin/asu-txt?-out=*pos.eq.ra;meta.main,*pos.eq.dec;meta.main,*$1"
fi

vizier_dataset=$(grep "#Table" -A1 catalogs.txt | awk '$1=="#Name:" {print $2}')

for DATASET in $vizier_dataset; do
        columns=$(grep -w -A5 "$DATASET" catalogs.txt | grep -w -E "pos.eq.ra|pos.eq.dec|$1" | awk '{print $1}')
        ast_columns=$(echo $columns | tr -s ' ' ',')
        if [ $(echo $ast_columns | tr -cd , | wc -c) -ge 2 ]
        then
                filename=$(echo $DATASET | tr -s '/' '_')
                astquery vizier -h0 --dataset=$DATASET --output="$filename".fits --overlapwith=$2 -c $ast_columns
        fi
done




