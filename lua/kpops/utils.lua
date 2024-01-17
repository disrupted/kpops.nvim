local M = {}

M.write_file = function(path, string)
  local fd = assert(vim.loop.fs_open(path, 'w', 438))
  assert(vim.loop.fs_write(fd, string, 0))
  assert(vim.loop.fs_close(fd))
end

M.write_tmpfile = function(string, basename)
  local path = os.tmpname()
  if basename ~= nil then
    local tmpdir = vim.fs.dirname(path)
    path = vim.fs.joinpath(tmpdir, basename)
  end
  local fd = assert(vim.loop.fs_open(path, 'w', 438))
  assert(vim.loop.fs_write(fd, string, 0))
  assert(vim.loop.fs_close(fd))
  return path
end

return M
