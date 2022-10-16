if vim.g.openingh then
  return
end
vim.g.openingh = true

local openingh = require("openingh")

vim.api.nvim_create_user_command("OpenInGHFile", function()
  openingh:openFile()
end, {})

vim.api.nvim_create_user_command("OpenInGHRepo", function()
  openingh:openRepo()
end, {})
