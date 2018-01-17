#! /bin/bash
set -e

# Usage: move-many-bitstreams-to-s3.sh

# Moves all bitstreams from the local filesystem assetstore 
# to an AWS S3 assetstore, using the parameters set in 
# move-bitstream-to-s2.sh

echo Transferring all local bitstreams to S3...

psql-query "select internal_id from bitstream where deleted=false and store_number=0 order by bitstream_id ASC" >s3-bitstreams.txt

while read item; do
    /home/ec2-user/bin/move-bitstream-to-s3.sh $item 
done <s3-bitstreams.txt

echo

