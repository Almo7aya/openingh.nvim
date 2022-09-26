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

-- returns the username and the reponame form the origin url in a table
function M.get_username_reponame(url)
  -- ssh has an @ in the url
  if string.find(url, "@") then
    local splitted_user_repo = M.split(url, ":")[2]
    local splitted_username_and_reponame = M.split(splitted_user_repo, "/")
    local username_and_reponame = {
      username = splitted_username_and_reponame[1],
      reponame = M.trim(string.gsub(splitted_username_and_reponame[2], ".git", "")),
    }

    return username_and_reponame
  else
    local splitted_username_and_reponame = M.split(url, "/")
    local username_and_reponame = {
      username = splitted_username_and_reponame[3],
      reponame = M.trim(string.gsub(splitted_username_and_reponame[4], ".git", "")),
    }

    return username_and_reponame
  end
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

  -- HEAD is detached returing commit hash
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

-- opens a url in the correct OS
function M.open_url(url)
  local os = vim.loop.os_uname().sysname
  if os == "Darwin" then
    io.popen("open " .. url)
    return true
  end

  if os == "Windows" then
    io.popen("start " .. url)
    return true
  end

  if os == "Linux" then
    io.popen("xdg-open " .. url)
    return true
  end

  return false
end

function M.print_no_remote_message()
  print("There is no git origin in this repo!")
end

return M
