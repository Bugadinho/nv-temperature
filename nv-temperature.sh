#!/usr/bin/env bash

DIRECTORY="/tmp/nv-temperature"
FILENAME="temperature"
FULL_PATH="${DIRECTORY}/${FILENAME}"

mkdir -p ${DIRECTORY}
echo 50000 > ${FULL_PATH}

while true
do
    TEMPERATURE=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
    RE='^[0-9]+$'
    if [[ $TEMPERATURE =~ $RE ]]
    then
        CORRECTED_TEMPERATURE="$((TEMPERATURE * 1000))"
        if ! [ "$(cat ${FULL_PATH})" = "$CORRECTED_TEMPERATURE" ]
        then
            echo "$CORRECTED_TEMPERATURE" > ${FULL_PATH}
        fi
    fi
    sleep 1
done