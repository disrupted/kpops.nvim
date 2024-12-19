local utils = require('kpops.utils')
local kpops = require('kpops.consts').KPOPS:lower()

local M = {}

---@return boolean
M.is_installed = function()
  return vim.fn.executable(kpops) == 1
end

---@param pipeline string
---@alias output_format 'yaml' | 'json'
---@param output? output_format
---@return string?
M.generate = function(pipeline, output)
  local cmd = { kpops, 'generate', pipeline }
  if output ~= nil then
    cmd = vim.list_extend(cmd, { '--output', output })
  end
  local result = vim.system(cmd, { text = true }):wait()
  if result.code ~= 0 then
    utils.error(string.format('error generating pipeline %s: %s', pipeline, result.stderr))
    return
  end
  return result.stdout
end

---@param scope schema_scope
---@return string?
M.schema = function(scope)
  local result = vim.system({ kpops, 'schema', scope }, { text = true }):wait()
  if result.code ~= 0 then
    utils.error(string.format('error generating %s schema: %s', scope, result.stderr))
    return
  end
  return result.stdout
end

---@return vim.Version
M.version = function()
  local result = vim.system({ kpops, '--version' }, { text = true }):wait()
  return assert(vim.version.parse(result.stdout))
end

---@async
---@param ... string
---@return vim.SystemObj
M.arbitrary = function(...)
  local task = vim.system({ kpops, ... }, { text = true }, function(result)
    if result.code ~= 0 and result.stderr then
      utils.error(result.stderr)
    end
    if result.stdout then
      M.notify(result.stdout)
    end
  end)
  return task
end

return M
