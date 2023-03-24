vim.g.test = true

describe("busted should run", function()
  it("should start test", function()
    vim.cmd([[packadd openingh.nvim]])
    local status = require("plenary.reload").reload_module(".nvim")
    assert.are.same(status, nil)
  end)

  it("require('openingh')", function()
    local status = require("openingh")
    assert.truthy(status)
  end)
end)

describe("openingh should set user commands", function()
  it("should set :OpenInGHRepo", function()
    local status = vim.fn.exists(":OpenInGHRepo")
    assert.truthy(status)
  end)

  it("should set :OpenInGHFile", function()
    local status = vim.fn.exists(":OpenInGHFile")
    assert.truthy(status)
  end)
end)

describe("openingh should open", function()
  it("repo on :OpenInGHRepo", function()
    vim.cmd("OpenInGHRepo")
    local status = vim.g.OPENINGH_RESULT
    assert.truthy(status)
  end)

  it("file on :OpenInGHFile", function()
    vim.cmd("e ./README.md")
    vim.api.nvim_win_set_cursor(0, { 3, 0 })
    vim.cmd("OpenInGHFile")
    local status = vim.g.OPENINGH_RESULT
    local expected = "/README.md#L3"
    assert.equal(expected, status:sub(-#expected))
  end)

  it("file range on :'<,'>OpenInGHFile", function()
    vim.cmd("e ./README.md")
    vim.api.nvim_buf_set_mark(0, "<", 5, 0, {})
    vim.api.nvim_buf_set_mark(0, ">", 10, 0, {})
    vim.cmd("'<,'>OpenInGHFile")
    local status = vim.g.OPENINGH_RESULT
    local expected = "/README.md#L5-L10"
    assert.equal(expected, status:sub(-#expected))
  end)

  it("file range using a keymap", function()
    vim.api.nvim_set_keymap("n", "ghf", ":OpenInGHFile <cr>", {})
    vim.cmd("e ./README.md")
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    vim.cmd("normal ghf")
    local status = vim.g.OPENINGH_RESULT
    local expected = "/README.md#L2"
    assert.equal(expected, status:sub(-#expected))
  end)
end)
