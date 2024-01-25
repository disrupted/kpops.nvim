local M = {}

local KPOPS = 'KPOps'

---@enum schema_scope
M.SCHEMA_SCOPE = {
  pipeline = 'pipeline',
  defaults = 'defaults',
  config = 'config',
}

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

---@alias semver_scope
---| 'major'
---| 'minor'
---| 'patch'

---@return { [semver_scope]: integer }
M.version = function()
  local result = vim.system({ KPOPS, '--version' }):wait()
  local version = result.stdout:sub(#KPOPS) -- remove KPOps prefix

  ---@type integer[]
  local major_minor_patch = {}
  for i in version:gmatch('([^.]+)') do
    table.insert(major_minor_patch, tonumber(i))
  end
  local major, minor, patch = unpack(major_minor_patch)
  return { major = major, minor = minor, patch = patch }
end

return M
