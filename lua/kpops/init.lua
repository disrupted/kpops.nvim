local lsp = require('kpops.lsp')

local M = {}

---@class DefaultConfig
local conf = {
  settings = {
    yaml = {
      editor = { formatOnType = true },
      ---@type table<string, string | string[]>
      schemas = {
        ['https://bakdata.github.io/kpops/3.0/schema/pipeline.json'] = {
          'pipeline.yaml',
          'pipeline_*.yaml',
        },
        ['https://bakdata.github.io/kpops/3.0/schema/defaults.json'] = {
          'defaults.yaml',
          'defaults_*.yaml',
        },
        ['https://bakdata.github.io/kpops/3.0/schema/config.json'] = {
          'config.yaml',
          'config_*.yaml',
        },
      },
    },
    kpops = {
      generate_schema = true,
    },
  },
}

-- -@param opts table<string, any>
M.setup = function(opts)
  conf = vim.tbl_deep_extend('force', conf, opts or {})
  lsp.setup(conf)
end

return M
