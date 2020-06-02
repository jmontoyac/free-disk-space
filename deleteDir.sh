#!/bin/bash
DELETEDIR="$1"
MAXSIZE="$2"
echo "Directory to be deleted: " $DELETEDIR
echo "MB size to keep in dir: " $MAXSIZE
if [[ -z "$DELETEDIR" || -z "$MAXSIZE" || "$MAXSIZE" -lt 1 ]]; then
    echo "usage: $0 [directory] [maxsize in megabytes]" >&2
    exit 1
fi
find "$DELETEDIR" -type f -printf "%T@::%p::%s\n" \
| sort -rn \
| awk -v maxbytes="$((1024 * 1024 * $MAXSIZE))" -F "::" '
  BEGIN { curSize=0; }
  { 
  curSize += $3;
  if (curSize > maxbytes) { print $2; }
  }
  ' \
  | tac | awk '{printf "%s\0",$0}' | xargs -0 -r rm 
