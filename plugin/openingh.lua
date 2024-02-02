if vim.g.openingh then
  return
end
vim.g.openingh = true

local openingh = require("openingh")

local function judge_priority(bang)
  -- When the command executed with bang `!`, prioritizes commit rather than branch.
  if bang then
    return openingh.priority.COMMIT
  else
    return openingh.priority.BRANCH
  end
end

vim.api.nvim_create_user_command("OpenInGHFile", function(opts)
  local url

  local branch = opts.fargs[1]
  if opts.range == 0 then -- Nothing was selected
    url = openingh.get_file_url(judge_priority(opts.bang), branch)
  else -- Current line or block was selected
    url = openingh.get_file_url(judge_priority(opts.bang), branch, opts.line1, opts.line2)
  end

  if opts.reg == "" then
    openingh.open_url(url)
  else
    vim.fn.setreg(opts.reg, url)
    print("URL put into register " .. opts.reg)
  end
end, {
  register = vim.g.openingh_copy_to_register,
  range = true,
  bang = true,
  nargs = "*",
})

vim.api.nvim_create_user_command("OpenInGHFileLines", function(opts)
  local url

  local branch = opts.fargs[1]
  if opts.range == 0 then -- Nothing was selected
    url = openingh.get_file_url(judge_priority(opts.bang), branch, opts.line1)
  else -- Current line or block was selected
    url = openingh.get_file_url(judge_priority(opts.bang), branch, opts.line1, opts.line2)
  end

  if opts.reg == "" then
    openingh.open_url(url)
  else
    vim.fn.setreg(opts.reg, url)
    print("URL put into register " .. opts.reg)
  end
end, {
  register = vim.g.openingh_copy_to_register,
  range = true,
  bang = true,
  nargs = "*",
})

vim.api.nvim_create_user_command("OpenInGHRepo", function(opts)
  local url = openingh.get_repo_url(judge_priority(opts.bang))

  if opts.reg == "" then
    openingh.open_url(url)
  else
    vim.fn.setreg(opts.reg, url)
    print("URL put into register " .. opts.reg)
  end
end, {
  register = vim.g.openingh_copy_to_register,
  bang = true,
})
