-- @related [init](lua/related-files/init.lua)

local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")

local default_opts = {}

local M = {}

local related = function(opts)
  local related_files = {}

  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  for index, line in ipairs(lines) do
    if string.match(line, " @related ") then
      for name, path in string.gmatch(line, " @related %[(.+)%]%((.+)%)") do
        if name then
          local entry = {
            bufnr = opts.bufnr,
            col = 0,
            filename = path,
            finish = 0,
            lnum = 0,
            start = 0,
            text = name,
            value = path,
          }
          -- table.insert(related_files, entry)
          table.insert(related_files, entry.filename)
        end
      end
    end
  end


  return related_files
end

M.current_file = function(opts)
  opts = opts or default_opts
  opts.bufnr = vim.F.if_nil(opts.bufnr, vim.fn.bufnr())

  local results = related(opts)

  pickers.new(opts, {
    prompt_title = "Related Files",
    finder = finders.new_table {
      results = results,
      -- entry_maker = make_entry.gen_from_quickfix(opts)
      entry_maker = make_entry.gen_from_file(opts)
    },
    selection_strategy = "reset",
    sorter = conf.generic_sorter(opts),
    border = {},
    -- previewer = nil,
  }):find()
end

return M
