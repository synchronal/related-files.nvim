local conf = require("telescope.config").values
local entry_display = require "telescope.pickers.entry_display"
local utils = require "telescope.utils"

local has_devicons, devicons = pcall(require, "nvim-web-devicons")

local get_devicon = function(filename)
  if has_devicons then
    local icon, icon_highlight = devicons.get_icon(filename, string.match(filename, "%a+$"), { default = true })
    local icon_display = icon or " "

    if conf.color_devicons then
      return icon_display, icon_highlight
    else
      return icon_display, "TelescopeResultsFileIcon"
    end
  else
    return " ", "TelescopeResultsFileIcon"
  end
end

local gen_from_related = function(opts)
  opts = opts or {}

  local display_items = {
    { width = 3 }, -- devicon
    { width = opts.name_width or 15 }, -- name
    { remaining = true }, -- filename{:optional_lnum+col} OR content preview
  }

  if opts.ignore_filename and opts.show_line then
    table.insert(display_items, 2, { width = 6 })
  end

  local displayer = entry_display.create {
    separator = " ",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = display_items,
  }

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)
    local icon, icon_highlight = get_devicon(filename)

    local display_columns = {
      { icon, icon_highlight, icon_highlight },
      { entry.text:lower(), "TelescopeResultsClass", "TelescopeResultsClass" },
      filename,
    }

    return displayer(display_columns)
  end

  return function(entry)
    local filename = entry.filename

    return {
      valid = true,

      value = entry,
      ordinal = entry.text,
      display = make_display,

      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      start = entry.start,
      finish = entry.finish,
      text = entry.text
    }
  end
end

return {
  gen_from_related = gen_from_related,
}
