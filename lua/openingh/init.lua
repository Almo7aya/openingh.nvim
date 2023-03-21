local utils = require("openingh.utils")
local M = {}

function M.setup()
  -- get the current working directory and set the url
  local current_buffer = vim.fn.expand("%:p:h")
  local repo_url = vim.fn.system("git -C " .. current_buffer .. " config --get remote.origin.url")

  if repo_url:len() == 0 then
    M.is_no_git_origin = true
    vim.g.openingh = false
    return
  end

  local gh = utils.parse_gh_remote(repo_url)
  if gh == nil then
    print("Error parsing GitHub remote URL")
    vim.g.openingh = false
    return
  end

  M.repo_url = string.format("http://%s/%s/%s", gh.host, gh.user_or_org, gh.reponame)
end

function M.openFile(range_start, range_end)
  -- make sure to update the current directory
  M.setup()
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

  local lines = nil

  if range_start and range_end then
    lines = "#L" .. range_start .. "-" .. "L" .. range_end
  else
    lines = "#L" .. utils.get_line_number_from_buf()
  end

  local current_branch_name_or_commit_hash = utils.get_current_branch_or_commit()

  local file_page_url = M.repo_url .. "/blob/" .. current_branch_name_or_commit_hash .. file_path .. lines

  local result = utils.open_url(file_page_url)

  if result == false then
    print("Unknown OS please open report")
  end
end

function M.openRepo()
  -- make sure to update the current directory
  M.setup()
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
