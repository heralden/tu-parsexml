#!/bin/sh

# Depends on libxml

# Remove xmllint shell-mode markings.
SED_SCRIPT="/^ -------$/d;/^\/ > $/d;/\/ >  -------/d;s/\&amp;/\&/"
# Basename for files temporarily saved in /tmp.
TMP="/tmp/$$-parse-xml"

# Print usage information if amount of args not equal to one
# or specified arg does not point to file.
if [ "$#" -ne 1 ] || ! [ -e "$1" ]; then
  echo "USAGE: $0 xml-file" >&2
  echo "Dependencies: libxml" >&2
  exit 1;
fi

# Grab specified fields and pipe to separate files.
for field in title category; do
  echo "cat /rss/channel/item/$field/text()" | xmllint --shell --nocdata "$1" | sed "$SED_SCRIPT" >> $TMP-$field
done

# Consolidate files so that the data is interleaved.
for i in $(seq 1 $(wc -l < $TMP-title)); do
  for field in category title; do
    sed -n "$i p" $TMP-$field >> $TMP-cons
  done
done

# Grep and edit output.
QUERY="Artikler"
grep -A 1 $QUERY $TMP-cons | sed "/$QUERY/d"

# Cleanup.
rm $TMP-title $TMP-category $TMP-cons
