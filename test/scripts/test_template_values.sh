#!/bin/bash
CHARTS_PATH=$1
CHARTS=`find ${CHARTS_PATH} -maxdepth 1 -mindepth 1 -type d`

for CHART in ${CHARTS}
do
    echo "Processing chart ${CHART}"
    find ${CHART} -wholename */test/values*.yaml -exec helm template ${CHART} --values {} \;
done