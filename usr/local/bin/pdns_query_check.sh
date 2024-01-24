#!/bin/bash

hostname=$(hostname -f)

dig_output=$(dig A $hostname @localhost +short)

if [ $? -gt 0 ] || [[ -z $dig_output ]]; then
    echo "FAIL"
    exit 1
fi

echo "OK"
exit 0
