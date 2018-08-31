#!/bin/sh

echo "Create database folder (if it doesn't exist already)..."
mkdir -p volumes/iri/mainnetdb/

echo "Delete old database..."
rm -rf volumes/iri/mainnetdb/*

echo "Download and unzipping latest database..."
curl -L https://s3-eu-west-1.amazonaws.com/iota.partners/iri-mainnetdb.tar.gz | tar zx -C ~/Iota/volumes/iri/mainnetdb/

echo "...finished!"
