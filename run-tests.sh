#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
which expect || err "Expect not found" 1
mkdir -p "${SCRIPT_DIR}/results"

ErrCount=0
TestCount=0

function err(){
  local msg
  local exit
  msg=${1}
  exit=${2}

  echo ${msg}
  ErrCount=$(expr ${ErrCount} + 1)
  if [ -n "${exit}" ]; then
    exit ${exit}
  fi
}

function test(){
  local src
  local target
  test=${1}
  src=${2}
  target=${3}

  TestCount=$(expr ${TestCount} + 1)
  rm -f "${target}"
  expect "${test}"
  cmp -s "${src}" "${target}" \
    || err "Generated file ${target} differs from expected result."
}

# -----
# Test Suite:

test "${SCRIPT_DIR}/test.only-defaults.expect" "${SCRIPT_DIR}/samples/.env.simple.sample.expected" "${SCRIPT_DIR}/results/.env.simple.result"
test "${SCRIPT_DIR}/test.with-comments.expect" "${SCRIPT_DIR}/samples/.env.with-comments.sample.expected" "${SCRIPT_DIR}/results/.env.with-comments.result"

# -----

echo $'\n'${ErrCount} 'Errors.'
if [ ${ErrCount} -eq 0 ]; then
  echo "All ${TestCount} tests pass."
  exit 0
else
  echo "${ErrCount} of ${TestCount} tests failed."
  exit 1
fi
