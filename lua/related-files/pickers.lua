-- @related [init](lua/related-files/init.lua)

local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local entry_maker = require("related-files.entry-maker")
local related = require('related-files.related-files')

local default_opts = {}

local M = {}

M.from_current_buffer = function(opts)
  opts = opts or default_opts
  opts.bufnr = vim.F.if_nil(opts.bufnr, vim.fn.bufnr())

  local results = related.from_current_buffer(opts)

  pickers.new(opts, {
    prompt_title = "Related Files",
    finder = finders.new_table {
      results = results,
      -- entry_maker = make_entry.gen_from_quickfix(opts)
      entry_maker = entry_maker.gen_from_related(opts)
    },
    selection_strategy = "reset",
    sorter = conf.generic_sorter(opts),
    border = {},
    -- previewer = nil,
  }):find()
end

return M
