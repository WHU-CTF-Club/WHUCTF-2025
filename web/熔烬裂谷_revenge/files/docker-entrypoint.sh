#!/bin/bash

if [ "$DASFLAG" ]; then
    INSERT_FLAG="$DASFLAG"
    unset DASFLAG
elif [ "$FLAG" ]; then
    INSERT_FLAG="$FLAG"
    unset FLAG
elif [ "$GZCTF_FLAG" ]; then
    INSERT_FLAG="$GZCTF_FLAG"
    unset GZCTF_FLAG
else
    INSERT_FLAG="flag{TEST_Dynamic_FLAG}"
fi

echo $INSERT_FLAG | tee /flag

chmod 400 /flag
chmod 4755 /readflag

nohup apache2-foreground >/dev/null 2>&1 &
gosu www-data "/app/app"

