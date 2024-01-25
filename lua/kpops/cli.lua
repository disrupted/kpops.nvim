local KPOPS = require('kpops.consts').KPOPS

local M = {}

---@return boolean
M.is_installed = function()
  return vim.fn.executable(KPOPS) == 1
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

  ---@type number[]
  local major_minor_patch = {}
  for part in version:gmatch('([^.]+)') do
    table.insert(major_minor_patch, tonumber(part))
  end
  local major, minor, patch = unpack(major_minor_patch)
  return { major = major, minor = minor, patch = patch }
end

return M
