#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s "${SCRIPT_DIR}/nvimd" ~/bin/nvimd
ln -s "${SCRIPT_DIR}/nvimd-server" ~/bin/nvimd-server
ln -s "${SCRIPT_DIR}/nvimd-clean" ~/bin/nvimd-clean
