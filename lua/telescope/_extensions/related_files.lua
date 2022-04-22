local ok, telescope = pcall(require, 'telescope')

if ok then
  local pickers = require'related-files.pickers'

  return telescope.register_extension {
    exports = {
      related_files = pickers.from_current_buffer,
    }
  }
end
