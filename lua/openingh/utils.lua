local M = {}

-- Notify the user that something went wrong
function M.notify(message, log_level)
  print(message)
  vim.notify({ message }, log_level, { title = "openingh.nvim" })
end

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
function M.get_default_branch()
  -- will return origin/[branch_name]
  local branch_with_origin = vim.fn.system("git rev-parse --abbrev-ref origin/HEAD")
  local branch_name = M.split(branch_with_origin, "/")[2]

  return M.trim(branch_name)
end

-- Checks if the supplied branch is available on the remote
function M.is_branch_upstreamed(branch)
  local output = M.trim(vim.fn.system("git ls-remote --exit-code --heads origin " .. branch))
  return output ~= ""
end

-- Get the current working branch
local function get_current_branch()
  return M.trim(vim.fn.system("git rev-parse --abbrev-ref HEAD"))
end

-- Get the commit hash of the most recent commit
local function get_current_commit_hash()
  return M.trim(vim.fn.system("git rev-parse HEAD"))
end

-- Checks if the supplied commit is available on the remote
function M.is_commit_upstreamed(commit_sha)
  local output = M.trim(vim.fn.system('git log --format="%H" --remotes'))
  return output:match(commit_sha) ~= nil
end

-- Returns the current branch or commit if they are available on remote
-- otherwise this will return the default branch of the repo
function M.get_current_branch_or_commit()
  local core = function()
    local current_branch = get_current_branch()
    if current_branch ~= "HEAD" and M.is_branch_upstreamed(current_branch) then
      return current_branch
    end

    local commit_hash = get_current_commit_hash()
    if current_branch == "HEAD" and M.is_commit_upstreamed(commit_hash) then
      return commit_hash
    end

    return M.get_default_branch()
  end

  return string.gsub(core(), "#", "%%23")
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
  local line_num = vim.api.nvim_win_get_cursor(0)[1]
  return line_num
end

-- opens a url in the correct OS
function M.open_url(url)
  -- when running in test env store the url
  if vim.g.test then
    vim.g.OPENINGH_RESULT = url
    return true
  end

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
