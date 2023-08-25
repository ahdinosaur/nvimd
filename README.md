# nvimd

For new-age `neovim` users with an antiquated dev style:

- Open a terminal
- From the terminal, open a file with `vim`
- Edit the file, do dah doo
- Close `vim`, go back to terminal
- Open the next file in `vim`
- Rinse repeat

`nvimd` helps you do this with a long-running `neovim` server, so you don't
have to wait for the LSP to boot up each time.

This is easier than changing how I use `vim`, maybe one day I'll learn. 🤷

## Install

### `nvimd` and `nvimd-server`

#### Http

Manually download [`nvimd`](https://github.com/ahdinosaur/nvimd/blob/main/nvimd)
and
[`nvimd-server`](https://github.com/ahdinosaur/nvimd/blob/main/nvimd-server)
into your preferred `bin` location (e.g. `$HOME/.local/bin).

#### Git

```shell
git clone https://github.com/ahdinosaur/nvimd
cd nvimd
./install.sh
```

This will install `nvimd` and `nvimd-server` to `$HOME/.local/bin` as symlinks
back to the `ahdinosaur/nvimd` git repo.

### Neovim config

Since `:q` will close the remote server, we need a special way to exit the
remote ui.

Add the following to your Lua `neovim` config

```lua
-- disconnect all remote-ui sessions
vim.keymap.set("n", "<leader>q", function()
  for _, ui in pairs(vim.api.nvim_list_uis()) do
    if ui.chan and not ui.stdout_tty then
      vim.fn.chanclose(ui.chan)
    end
  end
end, { noremap = true })
```

- [`neovim/neovim`#23093](https://github.com/neovim/neovim/issues/23093)

## Usage

When you start working on a project, in your project's root directory:

```shell
nvimd-server &
```

Then use `nvimd` as you would `nvim`:

```shell
nvimd path/to/file
```

## [License](./LICENSE)

```txt
Copyright 2023 Michael Williams

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
