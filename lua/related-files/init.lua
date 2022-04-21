local ok, telescope = pcall(require, "telescope")
if ok then
  vim.notify('loading related_files extension')
  telescope.load_extension('related_files')
end

if not ok then
  error('The related-files plugin requires nvim-telescope/telescope.nvim')
end
