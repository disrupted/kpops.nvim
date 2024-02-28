local lsp = require('kpops.lsp')
local commands = require('kpops.commands')
local config = require('kpops.config')

local M = {}

-- -@param opts table<string, any>
M.setup = function(opts)
  commands.setup()
  config = vim.tbl_deep_extend('force', config, opts or {})
  lsp.setup(config)
end

return M
