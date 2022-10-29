local eq = assert.are.same
local busted = require("plenary/busted")

describe("busted should run ", function()
  it(" should start test", function()
    vim.cmd([[packadd openingh.nvim]])
    local status = require("plenary.reload").reload_module(".nvim")
    eq(status, nil)
  end)
end)

