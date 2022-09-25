local utils = require("openingh.utils")
local M = {}

function M.setup()
  -- TODO - 1: add the repo path to global var
  M.cwd = vim.fn.getcwd()
  local repo_url = vim.fn.system("git config --get remote.origin.url")

  if repo_url:len() == 0 then
    M.is_no_git_origin = true
    vim.g.openingh = false
    return
  end

  local username_and_reponame = utils.get_username_reponame(repo_url)
  M.username = username_and_reponame.username
  M.reponame = username_and_reponame.reponame
  M.gh_url = "https://github.com/"
end

function M.openFile()
  -- TODO - 1: get the url from git folder
  -- TODO - 2: get the current line in the buffer and add it to the file url
  -- TODO - 3: get the selected range in the buffer and add it to the file url
  if M.is_no_git_origin then
    utils.print_no_remote_message()
    return
  end
end

function M.openRepo()
  if M.is_no_git_origin then
    utils.print_no_remote_message()
    return
  end

  local repo_url = M.gh_url .. M.username .. "/" .. M.reponame
  local result = utils.open_url(repo_url)

  if result then
    print("Opening url " .. repo_url)
  else
    print("Unknown OS please open report")
  end
end

return M
