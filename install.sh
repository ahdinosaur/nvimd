#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

ln -s "${SCRIPT_DIR}/nvimd" ~/.local/bin/nvimd
ln -s "${SCRIPT_DIR}/nvimd-server" ~/.local/bin/nvimd-server
