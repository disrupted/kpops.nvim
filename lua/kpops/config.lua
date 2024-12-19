local M = {}

---@class kpops.Config
---@field yamlls? lspconfig.Config: vim.lsp.ClientConfig
---@field kpops kpops.Config.Kpops

---@class kpops.Config.Kpops
---@field generate_schema boolean

---@return kpops.Config
local function get_defaults()
  local kpops = require('kpops.cli')
  local version = kpops.version()
  local major_minor = string.format('%d.%d', version.major, version.minor)
  return {
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
end

---@type kpops.Config
M.config = {}

---@class kpops.Opts: kpops.Config|{}
---@field kpops? kpops.Config.Kpops

---@param opts? kpops.Opts
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', get_defaults(), opts or {})
end

return M
