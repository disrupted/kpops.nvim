local lsp = require('kpops.lsp')

local M = {}
local conf = {}

M.setup = function(opts)
  conf = vim.tbl_deep_extend('force', conf, opts or {})
  lsp.setup(conf)
end

return M
