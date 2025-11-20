local M = {}

---@class kpops.Config
---@field yamlls? yaml_ls.lsp.Config | vim.lsp.Config
---@field kpops kpops.Config.Kpops

---@class yaml_ls.lsp.Config
---@field settings yaml_ls.settings

---@class yaml_ls.settings
---@field yaml yaml_ls.settings.yaml

---@class yaml_ls.settings.yaml
---@field schemas yaml_ls.settings.yaml.schemas
---@alias yaml_ls.settings.yaml.schemas table<string, string|string[]>

---@class kpops.Config.Kpops
---@field generate_schema boolean whether to generate schema
---@field watch boolean wether to watch for changes to the kpops.components package

---@return kpops.Config
local defaults = {
  yamlls = {
    settings = {
      yaml = {
        editor = { formatOnType = true },
        schemaStore = { enable = false },
        schemas = {},
      },
      redhat = {
        -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
        telemetry = { enabled = false },
      },
    },
  },
  kpops = {
    generate_schema = true,
    watch = true,
  },
}

---@type kpops.Config
---@diagnostic disable-next-line: missing-fields
M.config = {}

---@class kpops.Opts: kpops.Config|{}
---@field kpops? kpops.Config.Kpops

---@param opts? kpops.Opts
function M.setup(opts)
  M.config = vim.tbl_deep_extend('keep', defaults, opts or {})
end

return M
