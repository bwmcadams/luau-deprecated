#!/bin/sh
#
# Quick & dirty script to load the New York City Transit 
# Subway Data to mongo. Assumes mongo is running and such.
# 
# Data file is from: http://mta.info/developers/ 
# and freely available/redistributable.
# 
# Spec on the data format is available at: 
# http://code.google.com/transit/spec/transit_feed_specification.html
# 
# Not all optional (but all required) specification files are provided by 
# the MTA in the Subway files.
#

MONGO_IMPORT=/usr/bin/mongoimport
IMPORT_CMD="$MONGO_IMPORT -d nyct_subway --type csv --headerline --drop --ignoreBlanks"
MTA_ZIP="nyct_subway_100308.zip"
echo "Unzipping MTA File ($MTA_ZIP)"

unzip -o $MTA_ZIP

# Agency is malformed in current file release... Fix it

# add the missing endline character.
perl -pi -e 's/\r\n/\n/;' agency.txt
echo '\n' >> agency.txt

echo "Loading Agency file..."
$IMPORT_CMD -c agency agency.txt
echo "Loading Stops file..."
$IMPORT_CMD -c stops stops.txt
echo "Loading Routes file..."
$IMPORT_CMD -c routes routes.txt
echo "Loading Trips file..."
$IMPORT_CMD -c trips trips.txt
echo "Loading Stop Times file..."
$IMPORT_CMD -c stop_times stop_times.txt
echo "Loading Calendar file..."
$IMPORT_CMD -c calendar calendar.txt
echo "Loading Calendar Dates File..."
$IMPORT_CMD -c calendar_dates calendar_dates.txt
echo "Loading Shapes file..." # For line drawing - might be usable by GeoMongo
$IMPORT_CMD -c shapes shapes.txt
