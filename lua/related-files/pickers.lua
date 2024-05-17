-- @related [init](lua/related-files/init.lua)

local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
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
      entry_maker = entry_maker.gen_from_related(opts)
    },
    selection_strategy = "reset",
    sorter = conf.file_sorter(opts),
    border = {},
    previewer = previewers.cat.new({}),
  }):find()
end

return M
