#!/bin/sh

echo "Create database folder (if it doesn't exist already)..."
mkdir -p volumes/iri/mainnetdb/

echo "Delete old database..."
rm -rf volumes/iri/mainnetdb/*

echo "Download and unzipping latest database..."
curl -L https://x-vps.com/iota.db.tgz | tar zx -C ~/Iota/volumes/iri/mainnetdb/

echo "...finished!"
