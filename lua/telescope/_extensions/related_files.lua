local ok, telescope = pcall(require, 'telescope')

if ok then
  local related = require'related-files.related'

  return telescope.register_extension {
    exports = {
      related_files = related.current_file,
    }
  }
end
