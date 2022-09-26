local utils = require("openingh.utils")
local M = {}

function M.setup()
  local repo_url = vim.fn.system("git config --get remote.origin.url")

  if repo_url:len() == 0 then
    M.is_no_git_origin = true
    vim.g.openingh = false
    return
  end

  -- init global variables
  local username_and_reponame = utils.get_username_reponame(repo_url)
  M.username = username_and_reponame.username
  M.reponame = username_and_reponame.reponame
  M.gh_url = "https://github.com/"
  M.repo_url = M.gh_url .. M.username .. "/" .. M.reponame
end

function M.openFile()
  -- TODO - 3: get the selected range in the buffer and add it to the file url
  if M.is_no_git_origin then
    utils.print_no_remote_message()
    return
  end

  local file_path = utils.get_current_relative_file_path()

  -- if there is no buffer opened
  if file_path == "/" then
    print("There is no active file to open!")
    return
  end

  local current_branch_name = utils.get_current_branch()

  local file_page_url = M.repo_url .. "/blob/" .. current_branch_name .. file_path

  local result = utils.open_url(file_page_url)

  if result then
    print("Opening url " .. file_page_url)
  else
    print("Unknown OS please open report")
  end
end

function M.openRepo()
  if M.is_no_git_origin then
    utils.print_no_remote_message()
    return
  end

  local current_branch_name = utils.get_current_branch()

  local repo_page_url = M.repo_url .. "/tree/" .. current_branch_name

  local result = utils.open_url(repo_page_url)

  if result then
    print("Opening url " .. repo_page_url)
  else
    print("Unknown OS please open report")
  end
end

return M
