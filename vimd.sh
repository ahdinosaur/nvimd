#!/bin/bash

# - systemd socket service: https://github.com/neovim/neovim/issues/22602
#   - https://unix.stackexchange.com/questions/383678/on-demand-ssh-socks-proxy-through-systemd-user-units-with-socket-activation-does/635178#635178
# - detach TUI: https://github.com/neovim/neovim/issues/23093

DATA_DIR_PATH=".local/share/nvim/headless"
DATA_DIR="${HOME}/${DATA_DIR_PATH}"
SYSTEMD_DIR="/usr/lib/systemd/user"

mkdir -p "${SYSTEMD_DIR}"
mkdir -p "${DATA_DIR}"

sudo tee "${SYSTEMD_DIR}/neovim-headless-proxy@.socket" &>/dev/null <<EOF
[Unit]
Description=Socket activation for Neovim Headless

[Socket]
ListenStream=%h/${DATA_DIR_PATH}/activation/%i.socket

[Install]
WantedBy=sockets.target
EOF

sudo tee "${SYSTEMD_DIR}/neovim-headless-proxy@.service" &>/dev/null <<EOF

[Unit]
Description=Socket activation service for Neovim Seadless

## Stop also when stopped listening for socket-activation.
BindsTo=neovim-headless-proxy@%I.socket
After=neovim-headless-proxy@%I.socket

## Stop also when ssh-tunnel stops/breaks
#  (otherwise, could not restart).
BindsTo=neovim-headless@%I.service
After=neovim-headless@%I.service

[Service]
ExecStart=/lib/systemd/systemd-socket-proxyd --exit-idle-time=500s %h/${DATA_DIR_PATH}/activation/%i.socket
EOF

sudo tee "${SYSTEMD_DIR}/neovim-headless@.service" &>/dev/null <<EOF
[Unit]
Description=Neovim Headless

## Stop-when-idle is controlled by '--exit-idle-time=' in proxy.service
#  (from 'man systemd-socket-proxyd')
StopWhenUnneeded=true

[Service]
Type=simple
ExecStart=-/usr/bin/nvim --server %h/${DATA_DIR_PATH}/remote-ui/%i.socket
ExecStartPost=/bin/sleep 1
EOF

systemctl --user enable "$(systemd-escape --template neovim-headless@.service $(pwd))"
