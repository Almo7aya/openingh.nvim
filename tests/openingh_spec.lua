describe("busted should run", function()
  it(" should start test", function()
    vim.cmd([[packadd openingh.nvim]])
    local status = require("plenary.reload").reload_module(".nvim")
    assert.are.same(status, nil)
  end)

  it(" require('openingh')", function()
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

describe("openingh should open ", function()
  it("repo on :OpenInGHRepo", function()
    vim.fn.system("xdg-open() { export OpenInGHRepo=$0 }")
    vim.cmd("OpenInGHRepo")
    local status = vim.fn.system("echo $SHELL")

    print(os.getenv("MYVIMRC"))
    print(os.getenv("OpenInGHRepo"))

    print(vim.inspect(status))

    assert.truthy(status)
  end)

  it("file on :OpenInGHFile", function()
    vim.fn.system("xdg-open() { export OpenInGHFile=$1 }")
    vim.cmd("e ./README.md")
    vim.cmd("OpenInGHFile")
    local status = vim.fn.system("echo $OpenInGHFile")

    print(vim.inspect(status))

    assert.truthy(status)
  end)
end)
