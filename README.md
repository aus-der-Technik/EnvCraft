# EnvCraft

EnvCraft is an .env file creator. You feed it with a given env.sample file and EnvCraft will create a corresponding
.env file while asking you for all mandatory values.
EnvCraft supports defining default values ("press return to accept") and custom prompts.

## Usage

`./envcraft.sh [input file] [output file (defaults to .env)]`

## Format of input file

The simples format is just a number of variables to be filled, one per line, either with or without a trailing `=`:
```text
VARIABLE1=
VARIABLE2
VARIABLE3=
```
EnvCraft will ask you for a value for each, defaulting to no value.

If you want to define a default value for a variable, put a comment line starting with `# default:` in front of the
corresponding variable:

```text
# default: 13
VARIABLE1=
# default: foo
VARIABLE2
# default: spaces are also acceptable
VARIABLE3=
```

If you want to define custom prompts for a variable, add a comment line starting with `# prompt:` in front of the
corresponding variable:

```text
# prompt: Please define a value for variable 1 (typically a number)
# default: 13
VARIABLE1=
# prompt: Please provide a value for variable 2 (you can find that in our password safe as entry 'VARIABLE 2')
# default: foo
VARIABLE2
```

## Testing

Run `./run-tests.sh`.
