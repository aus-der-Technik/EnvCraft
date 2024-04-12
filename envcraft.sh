#!/usr/bin/env bash

#
# bapaEnv-bashparser-env-writer
#
# This Script parses the bapa file format, ask the user for input for each variable and
# writes it to dotenv.
#
# Bapa file format:
# ```
# # This is a comment and should be ignored
# default: 5
# MyVar1=7

# and this is a second block
# with another variable and a prompt
# default: world
# prompt: What is your name
# NAME=
# ```
#
# Each variable can have a description block. If the description block contains a line
# marked with `default: `, the value is accepted as default (user accepts with enter).
# Blocks can also contain `prompt: ` information. If a prompt is specified, then this
# is used as a question to the user, otherwise "Please enter a value" is used.
#

# get the file to process - first parameter.
INPUT_FILE=${1}
# get the file to write the output to - second parameter.
OUTPUT_FILE=${2:-.env}

# Process a configuration block.
# Configuration blocks can have a comment section and one variable
#
# eg:
# ```
# # This is a comment for the variable NAME.
# # The variable is enriched with a default value and a prompt.
# default: Bob
# prompt: What is your name
# NAME=
# ```
#
# The function returns a single line in the format: "VARIABLE;DEFAULT;PROMPT"
#
# Attention: No guards implemented. The latest value counts!
processBlock(){
	IN=${1}
	DEFAULT=
	PROMPT=
	VARIABLE=
	# For each line in this block
	while IFS= read -r line; do
		# Get the default out
		if [[ ${line} =~ "default:" ]]; then
			DEFAULT=$(
				echo "$line" | grep -oE 'default: [^ ]+' | cut -d ' ' -f 2-
			)
		fi
		# Get the prompt out
		if [[ ${line} =~ "prompt:" ]]; then
			PROMPT=$(
				echo "$line" | grep -oE 'prompt: .*' | cut -d ' ' -f 2-
			)
		fi
		# Get the variable out
		if ! [[ ${line} =~ "#" ]]; then
			if [[ ${line} != "" ]]; then
			VARIABLE=$(
				echo "$line" | cut -d '=' -f 1
			)
			fi

		fi
	done < <(echo "${IN}" )
	# return csv formated line
	echo "${VARIABLE};${DEFAULT};${PROMPT}";
}

# Read the config file in and process every chunk.
readFile(){
	INPUT_FILE=${1}
	local BUFFER
	while IFS= read -r line; do
		if [[ -z "$line" ]]; then
			continue
		fi
		BUFFER+=$(printf '%s\n' "$line")
		BUFFER+=$'\n'
		if ! [[ ${line} =~ "#" ]]; then
			processBlock "${BUFFER}"
			BUFFER=
		fi
	done < <(cat ${INPUT_FILE} )

	# There should be no unprocessed block left
	if [ "${#BUFFER}" -gt 0 ]; then
		echo "Left over error"
		exit 1
	fi
}

# Takes in the Bapa file format and outputs a dotenv
generateEnv(){
	local variable default prompt
	IFS=';' read -r variable default prompt <<< "$line"

  if [ ! -f "${OUTPUT_FILE}" ]; then
    mkdir -p "$(dirname "${OUTPUT_FILE}")" && touch "${OUTPUT_FILE}"
  fi
  source "${OUTPUT_FILE}"

  if [ -z "${!variable}" ]; then
    echo -n "${prompt:-Please enter a value for \"${variable}\"} (default: ${default:-<empty>}): "
    IFS= read -r VALUE < /dev/tty

    if [[ -z ${VALUE} ]]; then
      VALUE=${default}
    fi
    echo "${variable}=${VALUE}" >> "${OUTPUT_FILE}"
	fi
}

# input file must be given
if [[ -z ${INPUT_FILE} ]]; then
	echo "Usage: ${0} <input file> <output file, default to .env>"
	exit 1
fi

# go throw ever processed block and write the .env
while IFS= read -r line; do
	generateEnv $line
done < <(readFile "${INPUT_FILE}")
