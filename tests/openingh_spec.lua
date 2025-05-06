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

describe("OpenInGHFile", function()
  it("opens a URL that links to a file", function()
    vim.cmd("e ./README.md")
    vim.api.nvim_win_set_cursor(0, { 3, 0 })
    vim.cmd("OpenInGHFile")
    local status = vim.g.OPENINGH_RESULT
    local expected = "/README.md"
    assert.equal(expected, status:sub(-#expected))
  end)

  it("opens a URL that links to a file on the selected line", function()
    vim.cmd("e ./README.md")
    vim.api.nvim_buf_set_mark(0, "<", 5, 0, {})
    vim.api.nvim_buf_set_mark(0, ">", 5, 0, {})
    vim.cmd("'<,'>OpenInGHFile")
    local status = vim.g.OPENINGH_RESULT
    local expected = "/README.md#L5-L5"
    assert.equal(expected, status:sub(-#expected))
  end)

  it("opens a URL that links to a file with a range of selected lines", function()
    vim.cmd("e ./README.md")
    vim.api.nvim_buf_set_mark(0, "<", 5, 0, {})
    vim.api.nvim_buf_set_mark(0, ">", 10, 0, {})
    vim.cmd("'<,'>OpenInGHFile")
    local status = vim.g.OPENINGH_RESULT
    local expected = "/README.md#L5-L10"
    assert.equal(expected, status:sub(-#expected))
  end)

  it("opens a URL to a file using a keymap", function()
    vim.api.nvim_set_keymap("n", "ghf", ":OpenInGHFile <cr>", {})
    vim.cmd("e ./README.md")
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    vim.cmd("normal ghf")
    local status = vim.g.OPENINGH_RESULT
    local expected = "/README.md"
    assert.equal(expected, status:sub(-#expected))
  end)
end)

describe("OpenInGHRepo", function()
  it("opens a URL with a link to the repo", function()
    vim.cmd("OpenInGHRepo")
    local status = vim.g.OPENINGH_RESULT
    assert.truthy(status)
  end)
end)

describe("OpenInGHCommit", function()
  it("opens a URL with a link to the commit specified", function()
    vim.cmd('OpenInGHCommit "1b9ffd2"')
    local status = vim.g.OPENINGH_RESULT
    local expected = "/commit/1b9ffd2"
    assert.equal(expected, status:sub(-#expected))
  end)
end)
