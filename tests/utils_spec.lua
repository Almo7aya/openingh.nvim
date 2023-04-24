vim.g.test = true

local utils = require("openingh.utils")

describe("is_branch_upstreamed", function()
  it("returns false when the branch is not upstreamed", function()
    local output = utils.is_branch_upstreamed("this branch probably does not exist")
    assert.is.False(output)
  end)

  it("returns true when the branch is upstreamed", function()
    local output = utils.is_branch_upstreamed("main")
    assert.is.True(output)
  end)
end)

describe("is_commit_upstreamed", function()
  it("returns false when the commit is not upstreamed", function()
    local output = utils.is_commit_upstreamed("2a69ced1af827535dd8124eeab19d5f6777decf1")
    assert.is.False(output)
  end)

  it("returns true when the commit is upstreamed", function()
    local commit = utils.trim(vim.fn.system("git rev-parse HEAD"))
    local output = utils.is_commit_upstreamed(commit)
    assert.is.True(output)
  end)
end)
