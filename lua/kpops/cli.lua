local M = {}

M.schema = function(scope)
  local result = vim.system({ 'kpops', 'schema', scope }):wait()
  if result.code ~= 0 then
    vim.notify(
      ('KPOps error generating %s schema: %s'):format(scope, result.stderr),
      vim.log.levels.ERROR
    )
    return
  end
  return result.stdout
end

M.version = function()
  local result = vim.system({ 'kpops', '--version' }):wait()
  local version = result.stdout:sub(7) -- remove KPOps prefix

  local semver = {}
  for i in version:gmatch('([^.]+)') do
    table.insert(semver, tonumber(i))
  end
  return semver
end

return M
