local kpops = require('kpops.cli')
local utils = require('kpops.utils')

local M = {}

---@enum schema_scope
local SCOPE = {
  pipeline = 'pipeline',
  defaults = 'defaults',
  config = 'config',
}

---@param filename string
---@return schema_scope | nil
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

---@param scope schema_scope
---@return string | nil
M.generate = function(scope)
  if scope == SCOPE.defaults and vim.version.lt(kpops.version(), { 3 }) then
    vim.notify('KPOps v3+ is required for defaults schema', vim.log.levels.DEBUG)
    return
  end

  local schema = kpops.schema(scope)
  if schema ~= nil then
    local basename = string.format('kpops_schema_%s.json', scope)
    local schema_path = utils.write_tmpfile(basename, schema)
    return schema_path
  end
end

M.SCOPE = SCOPE

return M
