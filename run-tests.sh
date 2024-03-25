#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p "${SCRIPT_DIR}/results"

ErrCount=0
function err(){
  local msg
  msg=${1}

  echo ${msg}
  ErrCount=$(expr ${ErrCount} + 1)
}

rm -f "${SCRIPT_DIR}/results/.env.simple.result"
expect "${SCRIPT_DIR}"/test.only-defaults.expect
cmp -s "${SCRIPT_DIR}/samples/.env.simple.sample.expected" "${SCRIPT_DIR}/results/.env.simple.result" \
|| echo "Generated file ${SCRIPT_DIR}/results/.env.simple.result differs from expected result."

rm -f "${SCRIPT_DIR}/results/.env.with-comments.result"
expect "${SCRIPT_DIR}"/test.with-comments.expect
cmp -s "${SCRIPT_DIR}/samples/.env.with-comments.sample.expected" "${SCRIPT_DIR}/results/.env.with-comments.result" \
|| echo "Generated file ${SCRIPT_DIR}/results/.env.with-comments.result differs from expected result."


echo $'\n'${ErrCount} 'Errors.'
if [ ${ErrCount} -eq 0 ]; then
  echo "All tests passed."
  exit 0
else
  echo "Tests failed."
  exit 1
fi
