# openingh.nvim :octocat:
Opens the current project or file page in GitHub.
  - Features
    - Supports MacOS, Linux, and maybe Windows 🤷‍♂️
    - Works with detaches HEAD and support checked out branches
    - Automatically selects the correct line number in the file page 

## Requirements

  - Neovim 0.7.2+

## Installation

[packer](https://github.com/wbthomason/packer.nvim)

```lua
  use "almo7aya/neogruvbox.nvim"
```

## Commands

- `:OpenInGHRepo`
  - Opens the project's git repository page in GitHub.

- `:OpenInGHFile`
  - Opens the current file page in GitHub.

## Usage

You can call the commands directly or define mappings them:

```lua
-- for repository page
vim.api.nvim_set_keymap("n", "<Leader>gr", ":OpenInGHRepo <CR>", { expr = true, noremap = true })

-- for current file page
vim.api.nvim_set_keymap("n", "<Leader>gf", ":OpenInGHFile <CR>", { expr = true, noremap = true })
```

## TODO
  - [x] Support the current file cursor position
  - [ ] Support visual mode to open a file in range selection 

## License
[MIT](./LICENSE)

