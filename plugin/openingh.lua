if vim.g.openingh then
  return
end
vim.g.openingh = true

local openingh = require("openingh")

local complete_list = { openingh.priority.BRANCH, openingh.priority.COMMIT, }
local function complete_func(arg_lead, _, _)
  return vim.tbl_filter(function(item)
    return vim.startswith(item, arg_lead)
  end, complete_list)
end

vim.api.nvim_create_user_command("OpenInGHFile", function(opts)
  if opts.range == 0 then -- Nothing was selected
    openingh.open_file(opts.args)
  else -- Current line or block was selected
    openingh.open_file(opts.args, opts.line1, opts.line2)
  end
end, {
  range = true,
  nargs = '?',
  complete = complete_func,
})

vim.api.nvim_create_user_command("OpenInGHFileLines", function(opts)
  if opts.range == 0 then -- Nothing was selected
    openingh.open_file(opts.args, opts.line1)
  else -- Current line or block was selected
    openingh.open_file(opts.args, opts.line1, opts.line2)
  end
end, {
  range = true,
  nargs = '?',
  complete = complete_func,
})

vim.api.nvim_create_user_command("OpenInGHRepo", function(opts)
  openingh.open_repo(opts.args)
end, {
  nargs = '?',
  complete = complete_func,
})
