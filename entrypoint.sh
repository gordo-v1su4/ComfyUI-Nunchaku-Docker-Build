#!/bin/bash
set -e

# The CMD from the Dockerfile is passed as arguments to this script.
# We execute it, appending the arguments from the CLI_ARGS environment variable.
exec "$@" $CLI_ARGS
