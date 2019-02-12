#!/bin/bash

# Script to generate a list of items to be transferred to DASH
# Assumes the PGHOST and PGPASSWORD environment variables are set.

echo Creating list of items to transfer to DASH...

NUM_ITEMS=5000;
DANS_METADATA_FIELD=162

psql -qt -U dryad_app -d dryad_repo -c "select handle from handle where resource_id in (select item_id from item where in_archive=TRUE and owning_collection=2);" -o items.txt



echo List of items is in items.txt
