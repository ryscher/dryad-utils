#! /bin/bash
set -e

# Usage: move-bitstream-to-s3.sh <bitstream_internal_id>

# Moves a single bitstream from a local filesystem assetstore 
# to an AWS S3 assetstore.

assetstore_base="/opt/dryad/assetstore"
s3_bucket="dryad-assetstore-va"

echo Moving bitstream $1 to S3

# Get bitstream parameters from database
# Note: filename must be last, because the read command parses on spaces, 
# so a filename with spaces at the beginning would throw off the other variables.
read size_bytes store_number bitstream_deleted filename <<< $(psql-query \
"select size_bytes, store_number, deleted, name from bitstream where internal_id = '$1'" )

# Don't process if the item is not in local storage
if [ $store_number -ne 0 ] #|| [ $bitstream_deleted == "t" ]
then
    echo "$1 is not in local storage. Skipping."
    exit 1;
fi

# Print bitstream description
echo "Moving $filename (size $size_bytes) from store $store_number to S3"

# Get the bitstream's local path
dir_1=`echo $1 | cut -c1-2`
dir_2=`echo $1 | cut -c3-4`
dir_3=`echo $1 | cut -c5-6`
local_path="$assetstore_base/$dir_1/$dir_2/$dir_3/$1"
echo "Path is $local_path"

# Copy bitstream to S3
aws s3 cp $local_path s3://$s3_bucket/  

# Update DB to point to the new bitstream on S3
psql-query "update bitstream set store_number=1 where internal_id='$1'"

echo "Done."
