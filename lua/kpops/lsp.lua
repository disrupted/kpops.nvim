local utils = require('kpops.utils')
local schema = require('kpops.schema')
local coop = require('coop')

local M = {}

---@param scope schema_scope
---@param schema_path string
---@return yaml_ls.settings.yaml.schemas
local function make_schema(scope, schema_path)
  return {
    [schema_path] = {
      string.format('%s.yaml', scope),
      string.format('%s_*.yaml', scope),
    },
  }
end

---@param schemas yaml_ls.settings.yaml.schemas
---@param scope schema_scope
---@return boolean
M.schema_exists = function(schemas, scope)
  for _, registered_schema in ipairs(vim.tbl_keys(schemas)) do
    if registered_schema:match(scope) then
      return true
    end
  end
  return false
end

M.setup = function()
  local config = require('kpops.config').config
  vim.lsp.config('kpops', {
    -- https://github.com/redhat-developer/yaml-language-server
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml.kpops' },
    root_markers = { '.git' },
    ---@param client vim.lsp.Client
    ---@param bufnr uinteger
    on_attach = function(client, bufnr)
      coop.spawn(function()
        ---@type yaml_ls.lsp.Config|vim.lsp.ClientConfig
        local client_config = client.config
        local schemas = client_config.settings.yaml.schemas
        if config.kpops.generate_schema then
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local scope = assert(schema.match_kpops_file(filename))

          if M.schema_exists(schemas, scope) then
            return
          end

          local schema_path = assert(schema.generate(scope))
          schemas = vim.tbl_extend('force', schemas, make_schema(scope, schema_path))
          utils.notify(string.format('load %s schema', scope))
        elseif vim.tbl_isempty(schemas) then
          for scope in pairs(schema.SCOPE) do
            local schema_url = schema.online(scope)
            if schema_url then
              schemas = vim.tbl_extend('force', schemas, make_schema(scope, schema_url))
            end
          end
          utils.notify('load schemas')
        else
          return
        end

        client_config.settings.yaml.schemas = schemas
        utils.notify(vim.inspect(schemas), vim.log.levels.DEBUG)
        client:notify('workspace/didChangeConfiguration', { settings = client_config.settings })
        require('kpops.watcher').setup()
      end)
    end,
    settings = config.yamlls.settings,
    handlers = {
      ---@type lsp.Handler
      ['textDocument/publishDiagnostics'] = function(err, result, ctx)
        result.diagnostics = vim.tbl_filter(function(diagnostic)
          -- disable diagnostics for missing property
          -- these could be defined in the defaults (for pipeline.yaml)
          -- or as environment variables (for config.yaml)
          -- defaults.yaml does not have to be complete
          if diagnostic.message:match('Missing property ') then
            return false
          end

          return true
        end, result.diagnostics)

        vim.lsp.handlers[ctx.method](err, result, ctx)
      end,
    },
  })
  vim.lsp.enable('kpops')
end

return M
