# openingh.nvim
Opens the current file or project page in GitHub.

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/almo7aya/openingh.nvim?style=for-the-badge)
[![lint with luacheck](https://img.shields.io/github/actions/workflow/status/almo7aya/openingh.nvim/lint.yml?style=for-the-badge)](https://github.com/Almo7aya/openingh.nvim/actions/workflows/lint.yml)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/almo7aya/openingh.nvim/ci.yml?label=TESTS&style=for-the-badge)


  - Features
    - Supports macOS, Linux, Windows and WSL
    - Works with detached HEAD and supports checked out branches or forks
    - Automatically selects the correct line number on the file page 
    - Supports GitHub, GitHub Enterprise, GitLab, and Bitbucket  

  - Demo

![](./gifs/demo.gif)

## Requirements

  - Neovim 0.7.2+

## Installation

#### Example with Packer

[wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
-- init.lua
require("packer").startup(function()
  use "almo7aya/openingh.nvim"
end)
```

## Commands

- `:OpenInGHRepo`
  - Opens the project's git repository page in GitHub.

- `:OpenInGHFile`
  - Opens the current file page in GitHub. This command supports ranges.

- `:OpenInGHFileLines`
  - Opens the current file page in GitHub. This command supports ranges.

## Usage

You can call the commands directly or define mappings them:

```lua
-- for repository page
vim.api.nvim_set_keymap("n", "<Leader>gr", ":OpenInGHRepo <CR>", { silent = true, noremap = true })

-- for current file page
vim.api.nvim_set_keymap("n", "<Leader>gf", ":OpenInGHFile <CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>gf", ":OpenInGHFileLines <CR>", { silent = true, noremap = true })
```

## TODO

  - [x] Support the current file cursor position
  - [x] Support visual mode to open a file in range selection 
  - [x] Support other version control websites 

## Contribution

Feel free to open an issue or a pull request if you have any suggestions or improvements 

## License

[MIT](./LICENSE)

