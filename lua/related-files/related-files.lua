local from_current_buffer = function(opts)
  local related_files = {}

  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  for _index, line in ipairs(lines) do
    if string.match(line, " @related %[(.+)%]%(/?(.+)%)") then
      for name, path in string.gmatch(line, " @related %[(.+)%]%(/?(.+)%)") do
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

          table.insert(related_files, entry)
        end
      end
    end
  end


  return related_files
end

return {
  from_current_buffer = from_current_buffer,
}
