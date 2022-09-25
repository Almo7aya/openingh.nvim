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

-- returns the username and the reponame form the origin url in a table
function M.get_username_reponame(url)
  -- ssh has an @ in the url
  if string.find(url, "@") then
    local splitted_user_repo = M.split(url, ":")[2]
    local splitted_username_and_reponame = M.split(splitted_user_repo, "/")
    local username_and_reponame = {
      username = splitted_username_and_reponame[1],
      reponame = M.split(splitted_username_and_reponame[2], ".")[1],
    }

    return username_and_reponame
  else
    local splitted_username_and_reponame = M.split(url, "/")
    local username_and_reponame = {
      username = splitted_username_and_reponame[3],
      reponame = M.split(splitted_username_and_reponame[4], ".")[1],
    }

    return username_and_reponame
  end
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
