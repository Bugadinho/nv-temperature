#!/usr/bin/env bash

DIRECTORY="/tmp/nv-temperature"
GPU_COUNT="$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)"

mkdir -p ${DIRECTORY}

echo 50000 > "${DIRECTORY}/average"
for GPU in $(seq 0 $(($GPU_COUNT - 1)))
do
    FULL_PATH="${DIRECTORY}/gpu${GPU}"
    echo 50000 > ${FULL_PATH}
done

while true
do
    SUM=0
    GPUS=0

    for GPU in $(seq 0 $(($GPU_COUNT - 1)))
    do
        FULL_PATH="${DIRECTORY}/gpu${GPU}"
        TEMPERATURE=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader -i ${GPU})
        RE='^[0-9]+$'
        if [[ $TEMPERATURE =~ $RE ]]
        then
            CORRECTED_TEMPERATURE="$((TEMPERATURE * 1000))"
            SUM=$(($SUM + $CORRECTED_TEMPERATURE))
            GPUS=$(($GPUS + 1))
            if ! [ "$(cat ${FULL_PATH})" = "$CORRECTED_TEMPERATURE" ]
            then
                echo "$CORRECTED_TEMPERATURE" > ${FULL_PATH}
            fi
        fi
    done

    AVERAGE_TEMPERATURE=$(($SUM/$GPUS))
    echo $AVERAGE_TEMPERATURE > "${DIRECTORY}/average"

    sleep 1
done