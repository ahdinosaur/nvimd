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
into your preferred `bin` location (e.g. `$HOME/.local/bin`).

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

When you want to close your editor, use your special keymap (`<leader>q`)
instead of `:q`.

## FAQ

### Why?

Yes.

### How does this work?

We use the output of `tty` and `pwd` to construct a socket path.

Because [`neovim`'s server is not multi-tenant](https://github.com/neovim/neovim/issues/2161),
we need a separate server for each terminal (`tty`).

Also for the sake of plugins working as expected, we want a separate
server for each working directory (`pwd`)

When you run `nvimd-server`:

- Start a `nvim` server with the given socket path.
- In case this `nvim` server is shut down, restart in an infinite loop.
- If we get a signal to close this program, clean up the socket before exiting.

We need to start `nvimd-server &` in the terminal separately, so the terminal
is the parent, and when the terminal is closed, the server is closed.

When you run `nvimd`:

- Check if there is the socket exists
- If so, connect to the `nvim` server as a remote ui
- Otherwise, run `nvim` as usual

### Why does `nvimd-server` need to be started separately?

I was hoping `nvimd` could be used as a drop-in replacement for `nvim`.

If `nvimd-server` wasn't yet running, then run it when you call `nvimd` the
first time.

But I couldn't solve this issue:

- If `nvimd` starts `nvimd-server`, then `nvimd-server`'s parent process is
  `nvimd`.
- When that `nvimd` process eventually stops (because you're done editing your
  file), then `nvimd-server` has no parent and is re-parented to PID 1 (`init`).
- When you later are done and close your terminal, `nvimd-server` keeps running.

I think a proper solution would be something
[like how `screen` works](https://unix.stackexchange.com/a/193918).

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
