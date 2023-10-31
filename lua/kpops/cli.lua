local M = {}

M.schema = function(scope, module)
  local result = vim.system({ 'kpops', 'schema', scope, module }):wait()
  if result.code ~= 0 then
    vim.notify(
      ('KPOps error generating pipeline schema: %s'):format(result.stderr),
      vim.log.levels.ERROR
    )
    return
  end
  return result.stdout
end

return M
