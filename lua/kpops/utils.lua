local KPOPS = require('kpops.consts').KPOPS
local uv = require('coop.uv')

---@class KpopsUtils
local M = {}

---@async
---@param path string
---@param content string
M.write_file = function(path, content)
  local err_open, fd = uv.fs_open(path, 'w', 438)
  assert(not err_open, err_open)
  assert(fd)
  local err_write = uv.fs_write(fd, content, 0)
  assert(not err_write, err_write)
  local err_close = uv.fs_close(fd)
  assert(not err_close, err_close)
end

---@async
---@param basename string
---@param content string
---@return string path
M.write_tmpfile = function(basename, content)
  local path = os.tmpname()
  local tmpdir = vim.fs.dirname(path)
  path = vim.fs.joinpath(tmpdir, basename)
  M.write_file(path, content)
  return path
end

---@param msg string
---@param level integer?
M.notify = function(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = KPOPS })
end

---@param msg string
M.warn = function(msg)
  M.notify(msg, vim.log.levels.WARN)
end

---@param msg string
M.error = function(msg)
  M.notify(msg, vim.log.levels.ERROR)
end

return M
