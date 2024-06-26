local kpops = require('kpops.cli')
local version = kpops.version()
local major_minor = string.format('%d.%d', version.major, version.minor)

local M = {}

---@class DefaultConfig
M.defaults = {
  yamlls = {
    settings = {
      yaml = {
        editor = { formatOnType = true },
        ---@type table<string, string | string[]>
        schemas = {
          [('https://bakdata.github.io/kpops/%s/schema/pipeline.json'):format(major_minor)] = {
            'pipeline.yaml',
            'pipeline_*.yaml',
          },
          [('https://bakdata.github.io/kpops/%s/schema/defaults.json'):format(major_minor)] = {
            'defaults.yaml',
            'defaults_*.yaml',
          },
          [('https://bakdata.github.io/kpops/%s/schema/config.json'):format(major_minor)] = {
            'config.yaml',
            'config_*.yaml',
          },
        },
      },
    },
  },
  kpops = {
    generate_schema = true,
  },
}

---@type DefaultConfig
M.options = {}

---@param opts? DefaultConfig
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
end

return M
