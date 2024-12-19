local kpops = require('kpops.cli')
local utils = require('kpops.utils')

local M = {}

---@enum schema_scope
local SCOPE = {
  pipeline = 'pipeline',
  defaults = 'defaults',
  config = 'config',
}

---@param version vim.Version
---@param scope schema_scope
---@return boolean
local function version_supports_scope(version, scope)
  if scope == SCOPE.defaults and vim.version.lt(version, { 3 }) then
    utils.warn('Update to v3+ for defaults schema')
    return false
  end
  return true
end

---@param filename string
---@return schema_scope?
M.match_kpops_file = function(filename)
  local basename = assert(vim.fs.basename(filename))

  for scope in pairs(SCOPE) do
    local pattern = '^' .. scope .. '[_%w]*.yaml$'
    if basename:match(pattern) then
      return scope
    end
  end
end

---@param filename string
---@return boolean
M.is_kpops_file = function(filename)
  return M.match_kpops_file(filename) ~= nil
end

---@async
---@param scope schema_scope
---@return string? schema_path
M.generate = function(scope)
  if not version_supports_scope(kpops.version(), scope) then
    return
  end

  local schema = assert(kpops.schema(scope))
  local basename = string.format('kpops_schema_%s.json', scope)
  return utils.write_tmpfile(basename, schema)
end

---@async
---@param scope schema_scope
---@return string? schema_url
M.online = function(scope)
  local version = kpops.version()
  if not version_supports_scope(version, scope) then
    return
  end
  return string.format(
    'https://bakdata.github.io/kpops/%d.%d/schema/%s.json',
    version.major,
    version.minor,
    scope
  )
end

M.SCOPE = SCOPE

return M
