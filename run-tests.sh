#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
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
  expect "${SCRIPT_DIR}/tests/${test}" "./envcraft.sh" "${SCRIPT_DIR}/tests/samples/${src}" "${SCRIPT_DIR}/${target}"
  cmp -s "${SCRIPT_DIR}/tests/samples/${src}" "${SCRIPT_DIR}/${target}" \
    || err "Generated file ${target} differs from expected result."
}

# -----
# Test Suite:

which expect || err "Expect not found" 1
test "test.only-defaults.expect" ".env.simple.sample.expected" "results/.env.simple.result"
test "test.with-comments.expect" ".env.with-comments.sample.expected" "results/.env.with-comments.result"
test "test.with-hyphens.expect" ".env.with-hyphens.sample.expected" "results/.env.with-hyphens.result"
test "test.with-underscores.expect" ".env.with-underscores.sample.expected" "results/.env.with-underscores.result"
test "test.with-emojis.expect" ".env.with-emojis.sample.expected" "results/.env.with-emojis.result"
# -----

echo $'\n'${ErrCount} 'Errors.'
if [ ${ErrCount} -eq 0 ]; then
  echo "All ${TestCount} tests pass."
  exit 0
else
  echo "${ErrCount} of ${TestCount} tests failed."
  exit 1
fi
