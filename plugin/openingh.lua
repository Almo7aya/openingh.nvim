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
  local url

  if opts.range == 0 then -- Nothing was selected
    url = openingh.get_file_url(opts.args)
  else                    -- Current line or block was selected
    url = openingh.get_file_url(opts.args, opts.line1, opts.line2)
  end

  if opts.reg == "" then
    openingh.open_url(url)
  else
    vim.fn.setreg(opts.reg, url)
    print("URL yanked")
  end
end, {
  register = true,
  range = true,
  nargs = '?',
  complete = complete_func,
})

vim.api.nvim_create_user_command("OpenInGHFileLines", function(opts)
  local url

  if opts.range == 0 then -- Nothing was selected
    url = openingh.get_file_url(opts.args, opts.line1)
  else                    -- Current line or block was selected
    url = openingh.get_file_url(opts.args, opts.line1, opts.line2)
  end

  if opts.reg == "" then
    openingh.open_url(url)
  else
    vim.fn.setreg(opts.reg, url)
    print("URL yanked")
  end
end, {
  register = true,
  range = true,
  nargs = '?',
  complete = complete_func,
})

vim.api.nvim_create_user_command("OpenInGHRepo", function(opts)
  local url = openingh.get_repo_url(opts.args)

  if opts.reg == "" then
    openingh.open_url(url)
  else
    vim.fn.setreg(opts.reg, url)
    print("URL yanked")
  end
end, {
  register = true,
  nargs = '?',
  complete = complete_func,
})
