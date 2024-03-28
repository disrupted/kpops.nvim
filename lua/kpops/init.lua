local kpops = require('kpops.cli')
local lsp = require('kpops.lsp')
local commands = require('kpops.commands')
local config = require('kpops.config')

local M = {}

-- -@param opts table<string, any>
M.setup = function(opts)
  if not kpops.is_installed() then
    vim.notify('KPOps is not installed', vim.log.levels.WARN)
    return
  end

  commands.setup()
  config = vim.tbl_deep_extend('force', config, opts or {})
  lsp.setup(config)
end

return M
