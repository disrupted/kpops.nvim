local KPOPS = require('kpops.consts').KPOPS

local M = {}

---@return boolean
M.is_installed = function()
  return vim.fn.executable(KPOPS) == 1
end

---@param pipeline string
---@alias output_format 'yaml' | 'json'
---@param output? output_format
---@return string | nil
M.generate = function(pipeline, output)
  local cmd = { KPOPS, 'generate', pipeline }
  if output ~= nil then
    cmd = vim.list_extend(cmd, { '--output', output })
  end
  local result = vim.system(cmd):wait()
  if result.code ~= 0 then
    vim.notify(
      string.format('KPOps error generating pipeline %s: %s', pipeline, result.stderr),
      vim.log.levels.ERROR
    )
    return
  end
  return result.stdout
end

---@param scope schema_scope
---@return string | nil
M.schema = function(scope)
  local result = vim.system({ KPOPS, 'schema', scope }):wait()
  if result.code ~= 0 then
    vim.notify(
      string.format('KPOps error generating %s schema: %s', scope, result.stderr),
      vim.log.levels.ERROR
    )
    return
  end
  return result.stdout
end

---@alias semver_scope 'major' | 'minor' | 'patch'
---@return { [semver_scope]: number }
M.version = function()
  local result = vim.system({ KPOPS, '--version' }):wait()
  local version = result.stdout:sub(#KPOPS + 1) -- remove KPOps prefix
  local major, minor, patch = unpack(vim.split(version, '.', { plain = true }))
  return {
    major = tonumber(assert(major)),
    minor = tonumber(assert(minor)),
    patch = tonumber(assert(patch)),
  }
end

return M
