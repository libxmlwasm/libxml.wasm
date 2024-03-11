#!/bin/bash -e

QUERY="$1"
FILENAME="$2"
TMPFILE="$FILENAME.tmp.json"

cp "$FILENAME" "$TMPFILE"

jq "$QUERY" "$TMPFILE" > "$FILENAME"
rm "$TMPFILE"
