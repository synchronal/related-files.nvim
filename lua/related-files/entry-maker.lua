local utils = require "telescope.utils"
local Path = require "plenary.path"

local lookup_keys = {
  ordinal = 1,
  value = 1,
  filename = 1,
  cwd = 2,
}

local gen_from_related = function (opts)
  opts = opts or {}

  local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())
  local disable_devicons = opts.disable_devicons
  local mt_file_entry = {}

  mt_file_entry.cwd = cwd
  mt_file_entry.display = function(entry)
    local hl_group
    local display = utils.transform_path(opts, entry.value)

    display, hl_group = utils.transform_devicons(entry.value, display, disable_devicons)

    if hl_group then
      return display, { { { 1, 3 }, hl_group } }
    else
      return display
    end
  end

  mt_file_entry.__index = function(t, k)
    local raw = rawget(mt_file_entry, k)
    if raw then
      return raw
    end

    if k == "path" then
      local retpath = Path:new({ t.cwd, t.value }):absolute()
      if not vim.loop.fs_access(retpath, "R", nil) then
        retpath = t.value
      end
      return retpath
    end

    return rawget(t, rawget(lookup_keys, k))
  end

  return function(line)
    return setmetatable({ line }, mt_file_entry)
  end
end

return {
  gen_from_related = gen_from_related,
}
