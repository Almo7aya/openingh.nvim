local M = {}

-- the missing split lua method to split a string
function M.split(string, char)
  local array = {}
  local reg = string.format("([^%s]+)", char)
  for mem in string.gmatch(string, reg) do
    table.insert(array, mem)
  end
  return array
end

-- trim extra spaces and newlines
-- useful when working with git commands returned values
function M.trim(string)
  return (string:gsub("^%s*(.-)%s*$", "%1"))
end

-- returns a table with the host, user/org and the reponame given a github remote url
-- nil is returned when the url cannot be parsed
function M.parse_gh_remote(url)
  -- 3 capture groups for host, org/user and repo. whitespace is trimmed
  -- when cloning with http://, gh redirects to https://, but remote stays http
  local http = { string.find(url, "https?://([^/]*)/([^/]*)/([^%s/]*)") }
  -- ssh url can be of type:
  -- git@some.github.com:user_or_org/reponame.git
  -- ssh://git@some.github.com/user_or_org/reponame.git
  -- .* is used for ssh:// since lua matching doesn't support optional groups, only chars
  local ssh = { string.find(url, ".*git@(.*)[:/]([^/]*)/([^%s/]*)") }

  local matches = http[1] == nil and ssh or http
  if matches[1] == nil then
    return nil
  end

  local _, _, host, user_or_org, reponame = unpack(matches)
  return { host = host, user_or_org = user_or_org, reponame = string.gsub(reponame, ".git", "") }
end

-- get the remote default branch
function M.get_defualt_branch()
  -- will return origin/[branch_name]
  local branch_with_origin = vim.fn.system("git rev-parse --abbrev-ref origin/HEAD")
  local branch_name = M.split(branch_with_origin, "/")[2]

  return M.trim(branch_name)
end

-- get the active local branch or commit when HEAD is detached
function M.get_current_branch_or_commit()
  local current_branch_name = M.trim(vim.fn.system("git rev-parse --abbrev-ref HEAD"))

  -- HEAD is detached
  if current_branch_name ~= "HEAD" then
    return current_branch_name
  end

  local current_commit_hash = vim.fn.system("git rev-parse HEAD")
  return M.trim(current_commit_hash)
end

-- get the active buf relative file path form the .git
function M.get_current_relative_file_path()
  -- we only want the active buffer name
  local absolute_file_path = vim.api.nvim_buf_get_name(0)
  local git_path = vim.fn.system("git rev-parse --show-toplevel")

  local relative_file_path = "/" .. string.sub(absolute_file_path, git_path:len() + 1)

  return relative_file_path
end

-- get the line number in the buffer
function M.get_line_number_from_buf()
  local lineNum = vim.api.nvim__buf_stats(0).current_lnum
  return lineNum
end

-- opens a url in the correct OS
function M.open_url(url)
  -- order here matters
  -- wsl must come before win
  -- wsl must come before linux

  if vim.fn.has("mac") == 1 then
    vim.fn.system("open " .. url)
    return true
  end

  if vim.fn.has("wsl") == 1 then
    vim.fn.system("explorer.exe " .. url)
    return true
  end

  if vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
    vim.fn.system("start " .. url)
    return true
  end

  if vim.fn.has("linux") == 1 then
    vim.fn.system("xdg-open " .. url)
    return true
  end

  return false
end

function M.print_no_remote_message()
  print("There is no git origin in this repo!")
end

return M
