local kpops = require('kpops.cli')
local lsp = require('kpops.lsp')
local commands = require('kpops.commands')

local M = {}

---@param opts? DefaultConfig
M.setup = function(opts)
  if not kpops.is_installed() then
    vim.notify('KPOps is not installed', vim.log.levels.WARN)
    return
  end

  commands.setup()
  local Config = require('kpops.config')
  Config.setup(opts)
  -- config = vim.tbl_deep_extend('force', config, opts or {})
  lsp.setup()

  -- optional
  require('kpops.overseer')
end

return M
