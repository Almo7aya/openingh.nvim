if vim.g.openingh then
  return
end
vim.g.openingh = true

local openingh = require("openingh")

vim.api.nvim_create_user_command("OpenInGHFile", function(opts)
  if opts.range == 0 then -- Nothing was selected
    openingh.open_file()
  else -- Current line or block was selected
    openingh.open_file(opts.line1, opts.line2)
  end
end, {
  range = true,
})

vim.api.nvim_create_user_command("OpenInGHFileLines", function(opts)
  if opts.range == 0 then -- Nothing was selected
    openingh.open_file(opts.line1)
  else -- Current line or block was selected
    openingh.open_file(opts.line1, opts.line2)
  end
end, {
  range = true,
})

vim.api.nvim_create_user_command("OpenInGHRepo", function()
  openingh.open_repo()
end, {})
