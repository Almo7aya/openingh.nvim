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

  local line_number = utils.get_line_number_from_buf()
  local current_branch_name_or_commit_hash = utils.get_current_branch_or_commit()

  local file_page_url = M.repo_url .. "/blob/" .. current_branch_name_or_commit_hash .. file_path .. "#L" .. line_number

  local result = utils.open_url(file_page_url)

  if result == false then
    print("Unknown OS please open report")
  end
end

function M.openRepo()
  if M.is_no_git_origin then
    utils.print_no_remote_message()
    return
  end

  local current_branch_name_or_commit_hash = utils.get_current_branch_or_commit()

  local repo_page_url = M.repo_url .. "/tree/" .. current_branch_name_or_commit_hash

  local result = utils.open_url(repo_page_url)

  if result == false then
    print("Unknown OS please open report")
  end
end

return M
