local M = {}

---@class kpops.Config
---@field yamlls? vim.lsp.Config
---@field kpops kpops.Config.Kpops

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
        ---@type table<string, string | string[]>
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
