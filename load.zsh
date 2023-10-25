# nvimd-server
autoload -Uz add-zsh-hook
load-nvimd() {
  emulate -L zsh
  CWD=$(pwd)
  if [[ "${NVIMD_SERVER_INIT:-}" != "${CWD}" ]]
  then
    export NVIMD_SERVER_INIT="${CWD}"

    JS="${CWD}/package.json"
    RUST="${CWD}/Cargo.toml"

    if [[ -f "${JS}" || -f "${RUST}" ]]
    then
      nvimd-server &
    fi
  fi
}
add-zsh-hook chpwd load-nvimd
load-nvimd
