if vim.g.openingh then
  return
end
vim.g.openingh = true

local openingh = require("openingh")

vim.api.nvim_create_user_command("OpenInGHFile", function(opts)
  if opts.range == 0 or opts.range == 1 then
    openingh.openFile()
  else
    openingh.openFile(opts.line1, opts.line2)
  end
end, {
  range = true,
})

vim.api.nvim_create_user_command("OpenInGHRepo", function()
  openingh:openRepo()
end, {})
