local M = {}

M.write_file = function(path, string)
  local fd = assert(vim.loop.fs_open(path, 'w', 438))
  assert(vim.loop.fs_write(fd, string, 0))
  assert(vim.loop.fs_close(fd))
end

return M
