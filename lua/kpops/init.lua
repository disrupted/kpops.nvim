local kpops = require('kpops.cli')
local lsp = require('kpops.lsp')
local commands = require('kpops.commands')
local utils = require('kpops.utils')

local M = {}

---@param opts? kpops.Opts
M.setup = function(opts)
  if not kpops.is_installed() then
    utils.error(string.format('%s is not installed', require('kpops.consts').KPOPS:lower()))
    return
  end

  commands.setup()
  local Config = require('kpops.config')
  Config.setup(opts)
  lsp.setup()

  -- optional
  require('kpops.overseer')
end

return M
