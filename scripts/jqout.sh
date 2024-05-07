#!/bin/bash -e

# jqout.sh - Query a JSON file with jq and save the result back to the file

QUERY="$1"
FILENAME="$2"
TMPFILE="$FILENAME.tmp.json"

cp "$FILENAME" "$TMPFILE"

jq "$QUERY" "$TMPFILE" > "$FILENAME"
rm "$TMPFILE"
