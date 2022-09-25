if vim.g.openingh then
    return
end
vim.g.openingh = true

require("openingh").setup(true)

vim.api.nvim_create_user_command("OpenInGHFile", function()
    require("openingh").openFile()
end, {})

vim.api.nvim_create_user_command("OpenInGHRepo", function()
    require("openingh"):openRepo()
end, {})

