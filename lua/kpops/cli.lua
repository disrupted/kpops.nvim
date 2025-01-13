local utils = require('kpops.utils')
local kpops = require('kpops.consts').KPOPS:lower()
local system = require('coop.vim').system

local M = {}

---@return boolean
M.is_installed = function()
  return vim.fn.executable(kpops) == 1
end

---@async
---@param pipeline string
---@return string? stdout
M.generate = function(pipeline)
  local cmd = { kpops, 'generate', pipeline }
  local result = system(cmd)
  if result.code ~= 0 then
    utils.error(string.format('error generating pipeline %s: %s', pipeline, result.stderr))
    return
  end
  return result.stdout
end

---@async
---@param scope schema_scope
---@return string? stdout
M.schema = function(scope)
  utils.notify(string.format('generating %s schema', scope))
  local result = system({ kpops, 'schema', scope })
  if result.code ~= 0 then
    utils.error(string.format('error generating %s schema: %s', scope, result.stderr))
    return
  end
  return result.stdout
end

---@async
---@return vim.Version
M.version = function()
  local result = system({ kpops, '--version' })
  local version = assert(vim.version.parse(result.stdout))
  return version
end

---@async
---@param ... string
---@return vim.SystemCompleted
M.arbitrary = function(...)
  local result = system({ kpops, ... })
  if result.code ~= 0 and result.stderr then
    utils.error(result.stderr)
  end
  if result.stdout then
    utils.notify(result.stdout)
  end
  return result
end

return M
