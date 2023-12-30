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

describe("encode_uri_component", function()
  it("returns the given string without any change if it doesn't contain any uri reserved characters", function()
    local input = "asdf_12345.QWER~yuio-hjkl"
    local output = utils.encode_uri_component(input)
    assert.is.Equal(input, output)
  end)

  it("returns an encoded string that all non-uri-unreserved characters are converted", function()
    local input = ""
    for i = 0, 127 do
      input = input .. string.char(i)
    end
    local output = utils.encode_uri_component(input)
    assert.is.Equal("%00%01%02%03%04%05%06%07%08%09%0A%0B%0C%0D%0E%0F%10%11%12%13%14%15%16%17%18%19%1A%1B%1C%1D%1E%1F%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-.%2F0123456789%3A%3B%3C%3D%3E%3F%40ABCDEFGHIJKLMNOPQRSTUVWXYZ%5B%5C%5D%5E_%60abcdefghijklmnopqrstuvwxyz%7B%7C%7D~%7F", output)
  end)

  it("returns encoded string for a non-ascii string input (UTF-8)", function()
    local input = "ほげ" -- UTF-8 bytewise representation is "e3 81 bb e3 81 92" 
    local output = utils.encode_uri_component(input)
    assert.is.Equal("%E3%81%BB%E3%81%92", output)
  end)
end)
