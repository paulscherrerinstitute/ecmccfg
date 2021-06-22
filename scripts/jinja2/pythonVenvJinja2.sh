#!/bin/bash
set -e

while getopts d:t:D:o: arg
do
    case "${arg}" in
        d) TMP_DIR=${OPTARG};;
        t) TEMPLATE=${OPTARG};;
        D) DATA=${OPTARG};;
        o) OUTFILE=${OPTARG};;
    esac
done

#SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

ENV_DIR=${TMP_DIR}/.venv

if [ -d "${ENV_DIR}" ]; then
    source "${ENV_DIR}"/bin/activate
else
    python3 -m venv "${ENV_DIR}"
    source "${ENV_DIR}"/bin/activate
    pip3 install -r ${TMP_DIR}/requirements.txt
fi

jinja2 ${TEMPLATE} ${DATA} -o ${OUTFILE}
