#!/bin/bash -xe

if [[ "$1" == "INTEGRATION" ]]
then
    PREFIX="I"
elif [[ "$1" == "NIGHTLY" ]]
then
    PREFIX="N"
elif [[ "$1" == "MAINTENANCE" ]]
then
    PREFIX="M"
else
    "Please use $0 {INTEGRATION,NIGHTLY,MAINTENANCE}"
fi

LATEST=`curl -s http://download.eclipse.org/eclipse/downloads/ \
    | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' \
    | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' \
    | grep -e "${PREFIX}2017" \
    | grep -v testResults \
    | sed -e 's:^drops4/::' -e 's:/$::' \
    | sort -u \
    | tail -n1`

CURRENT=`xmllint --noblanks pom.xml \
    | egrep -o '<build-name>[^>]+<\/build-name>' \
    | sed -e 's/<build-name>//' -e 's/<\/build-name>//'`