local kpops = require('kpops.cli')
local schema = require('kpops.schema')
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

local M = {}

---@param conf table<string, any>
M.setup = function(conf)
  configs.kpops = {
    -- https://github.com/redhat-developer/yaml-language-server
    default_config = {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml.kpops' },
      root_dir = function(filename)
        local cwd = lspconfig.util.find_git_ancestor(filename) or vim.loop.cwd()
        return cwd
      end,
      on_attach = function(client, bufnr)
        local config = client.config
        ---@cast config DefaultConfig

        if config.settings.kpops.generate_schema then
          local filename = vim.api.nvim_buf_get_name(bufnr)
          schema.match_kpops_file(filename)
          local scope = assert(schema.match_kpops_file(filename))
          local schema_path = schema.generate(scope)
          if not schema_path then
            return
          end
          local schemas = config.settings.yaml.schemas

          -- remove previously registered schema for scope
          for _, registered_schema in ipairs(vim.tbl_keys(schemas)) do
            if registered_schema:match(scope) then
              schemas[registered_schema] = nil
            end
          end

          -- register new schema
          schemas[schema_path] = {
            scope .. '.yaml',
            scope .. '_*.yaml',
          }

          vim.notify('reload KPOps schemas')
          vim.notify(vim.inspect(client.config.settings.yaml.schemas), vim.log.levels.DEBUG)
          client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
        end
      end,
      single_file_support = false,
      settings = {
        -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
        redhat = { telemetry = { enabled = false } },
        yaml = {},
      },
      handlers = {
        ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
          result.diagnostics = vim.tbl_filter(function(diagnostic)
            -- disable diagnostics for missing property
            -- these could be defined in the defaults (for pipeline.yaml)
            -- or as environment variables (for config.yaml)
            if diagnostic.message:match('Missing property ') then
              return false
            end

            return true
          end, result.diagnostics)

          vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx, config)
        end,
      },
    },
  }
  lspconfig.kpops.setup(conf)
end

return M
