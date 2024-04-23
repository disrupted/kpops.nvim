local M = {}

---@param path string
---@param content string
M.write_file = function(path, content)
  local fd = assert(vim.uv.fs_open(path, 'w', 438))
  assert(vim.uv.fs_write(fd, content, 0))
  assert(vim.uv.fs_close(fd))
end

---@param basename string
---@param content string
---@return string
M.write_tmpfile = function(basename, content)
  local path = os.tmpname()
  if basename ~= nil then
    local tmpdir = vim.fs.dirname(path)
    path = vim.fs.joinpath(tmpdir, basename)
  end
  local fd = assert(vim.uv.fs_open(path, 'w', 438))
  assert(vim.uv.fs_write(fd, content, 0))
  assert(vim.uv.fs_close(fd))
  return path
end

return M
