
#saves output into a csv file
#arguments: 1 -> tab delimited file

echo "Creating a coma delimited version of $1"
cat $1 | tr -s "/t" "," >> $1.csv
echo "Done!"
exit