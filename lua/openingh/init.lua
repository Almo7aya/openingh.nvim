
local M = {
  setup = function (debug)
    -- TODO - 1: add the repo path to global var
    if (debug) then
      print("debugging openingh.nvim")
    end
  end,

  openFile = function ()
    -- TODO - 1: get the url from git folder
    -- TODO - 2: get the current line in the buffer and add it to the file url 
    -- TODO - 3: get the selected range in the buffer and add it to the file url 
  end,

  openRepo = function ()
    -- TODO - 1: get the remote url and open it
  end
}

return M
