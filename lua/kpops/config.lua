local M = {}

---@class kpops.Config
---@field yamlls? lspconfig.Config: vim.lsp.ClientConfig
---@field kpops kpops.Config.Kpops

---@class kpops.Config.Kpops
---@field generate_schema boolean

---@return kpops.Config
local defaults = {
  yamlls = {
    settings = {
      yaml = {
        editor = { formatOnType = true },
        ---@type table<string, string | string[]>
        schemas = {},
      },
    },
  },
  kpops = {
    generate_schema = true,
  },
}

---@type kpops.Config
M.config = {}

---@class kpops.Opts: kpops.Config|{}
---@field kpops? kpops.Config.Kpops

---@param opts? kpops.Opts
function M.setup(opts)
  M.config = vim.tbl_deep_extend('keep', defaults, opts or {})
end

return M
