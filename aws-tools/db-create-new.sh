#!/bin/bash

# A script to launch a new Amazon RDS machine, with a copy of a recent Dryad database.
# A recent database export is assumed to be in
#   /opt/dryad-data/databaseBackups/dryadDBlatest-00_30.sql
#
# Usage: db-create-new.sh new-machine-name new-db-password

usage() {
    echo "Usage: $NAME new-machine-name new-db-password"
    exit 1
}

NAME=`basename $0`

if [ $# != 2 ] ; then echo "Need two argments" ; usage ; fi

NEW_MACHINE_NAME="$1"
NEW_DB_PASSWORD="$2"

echo Creating a new Dryad database database with a copy of production content...

sudo touch /tmp/sudotest

# create a new RDS
echo "aws rds create-db-instance --db-name dryad_repo --db-instance-identifier $NEW_MACHINE_NAME --allocated-storage 50 --db-instance-class db.t2.small --engine postgres --master-username dryad_app --master-user-password $NEW_DB_PASSWORD --publicly-accessible --vpc-security-group-ids \"sg-77d83c0b\""

aws rds create-db-instance --db-name dryad_repo --db-instance-identifier $NEW_MACHINE_NAME --allocated-storage 50 --db-instance-class db.t2.small --engine postgres --master-username dryad_app --master-user-password $NEW_DB_PASSWORD --publicly-accessible --vpc-security-group-ids "sg-77d83c0b"

# wait for the database creation to complete
sleep 300

# populate the new database from a recent backup of production (change the hostname)
PGPASSWORD=$NEW_DB_PASSWORD
pg_restore -j 4 --host=$NEW_MACHINE_NAME.co33oyzjqasf.us-east-1.rds.amazonaws.com -d dryad_repo -U dryad_app /opt/dryad-data/databaseBackups/dryadDBlatest-00_30.sql

echo
echo     ====  Creation Succeeded  ====
echo     ====  Full machine name is $NEW_MACHINE_NAME.co33oyzjqasf.us-east-1.rds.amazonaws.com ====
echo

