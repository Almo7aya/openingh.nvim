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

function M.get_defualt_branch()
  -- will return origin/[branch_name]
  local branch_with_origin = vim.fn.system("git rev-parse --abbrev-ref origin/HEAD")
  local branch_name = M.split(branch_with_origin, "/")[2]

  return M.trim(branch_name)
end

function M.get_current_branch()
  local current_branch_name = vim.fn.system("git rev-parse --abbrev-ref HEAD")
  return M.trim(current_branch_name)
end

-- opens a url in the correct OS
function M.open_url(url)
  local os = M.get_os()

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

function M.get_os()
  local os_name = vim.loop.os_uname().sysname
  return os_name
end

function M.print_no_remote_message()
  print("There is no git origin in this repo!")
end

return M
