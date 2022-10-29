local eq = assert.are.same
local busted = require("plenary/busted")

before_each(function()
  vim.cmd([[packadd openingh.nvim]])
end)

describe("busted should run ", function()
  it(" should start test", function()
    local status = require("plenary.reload").reload_module(".nvim")
    eq(status, nil)
  end)

  it("openingh should be available", function()
    local status = require("openingh")
    assert.truthy(status)
  end)
end)
