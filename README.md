# Vizier-query --Adrihp06
 The goal for this program is to given a certain image, obtain all the information for a column in vizier.
 
 Example of program usage:
 ./vizierquery.sh src.redfhift NGC_1042.fits
 ----Program-----ucd filter---image----
 
We started using a gnuastro tool objects info:

 'centerra=$(astfits -h0 $2 --skycoverage | grep "Center:" | awk '{print $2}')
centerde=$(astfits -h0 $2 --skycoverage | grep "Center:" | awk '{print $3}')
rad=$(astfits -h0 $2 --skycoverage | grep "Width:" | awk '{print $2}')'

With that we obtain the center and the radio, this is necessary because we need to search for objects in our image.

Then with this we make the curl petition usign --form to pass the filter for the search. With -c and -c.rm we include the center and radio and with -ucd the column we want obtain.

Actually this program only works with the ucd nomenclature (you can look for it in http://cdsweb.u-strasbg.fr/UCD/ucd1p-words.txt)

This curl download a file 'catalogs.txt' with information from these catalogs, the tables and the columns that over lap with the image.
We can change '?-out=*pos.eq.ra;meta.main,*pos.eq.dec;meta.main,*$1"' for '?-meta.all' and with that we only obtain information about the databases, although this looks more optimal, it has its problems.

The ucd filter works at catalogs level. This means all the catalogs which over laps with the image and have the desire column will be shown in the file 'catalogs.txt', the problems is that most of the catalogs have several tables so and not all of them have the information we want and it don't show columns names from the tables. 

My idea to solve that and make it the most optimal possible is to add '?-out=*pos.eq.ra;meta.main,*pos.eq.dec;meta.main,*$1" the file will print all the tables for the catalogs but with:
 
  'columns=$(grep -w -A5 "$DATASET" catalogs.txt | grep -w -E "pos.eq.ra|pos.eq.dec|$1" | awk '{print $1}')'
 
We avoid those empty tables and obtain the column name.

Then using astquery we obtain the tables that have 3 or more columns, this is because there are tables that are not empty but only have RA and DE columns.

There is still a lot to improve but I will be working on it. :-)
