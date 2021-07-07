#!/bin/bash
set -e

while getopts d: arg
do
    case "${arg}" in
        d) TMP_DIR=${OPTARG};;
    esac
done

ENV_DIR="${TMP_DIR=/tmp}"/.venv

if [ -d "${ENV_DIR}" ]; then
    . "${ENV_DIR}"/bin/activate
else
    python3 -m venv "${ENV_DIR}"
    . "${ENV_DIR}"/bin/activate
    pip3 install pyyaml jinja2-cli
fi

