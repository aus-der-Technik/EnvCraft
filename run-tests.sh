#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p "${SCRIPT_DIR}/results"

expect "${SCRIPT_DIR}"/test.only-defaults.expect
cmp -s "${SCRIPT_DIR}/samples/.env.simple.sample.expected" "${SCRIPT_DIR}./results/.env.simple.result" \
|| echo "Generated file ${SCRIPT_DIR}./results/.env.simple.result differs from expected result."

expect "${SCRIPT_DIR}"/test.with-comments.expect
cmp -s "${SCRIPT_DIR}/samples/.env.with-comments.sample.expected" "${SCRIPT_DIR}./results/.env.with-comments.result" \
|| echo "Generated file ${SCRIPT_DIR}./results/.env.with-comments.result differs from expected result."

