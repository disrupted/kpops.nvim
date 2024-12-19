local utils = require('kpops.utils')
local M = {}

M.setup = function()
  local config = require('kpops.config').config
  require('lspconfig.configs').kpops = {
    -- https://github.com/redhat-developer/yaml-language-server
    default_config = {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml.kpops' },
      root_dir = function(filename)
        return vim.fs.root(filename, { '.git' }) or vim.uv.cwd()
      end,
      on_attach = function(client, bufnr)
        if config.kpops.generate_schema then
          local schema = require('kpops.schema')
          local filename = vim.api.nvim_buf_get_name(bufnr)
          local scope = assert(schema.match_kpops_file(filename))
          local schema_path = schema.generate(scope)
          if not schema_path then
            return
          end
          local schemas = client.config.settings.yaml.schemas

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

          utils.notify('reload schemas')
          utils.notify(vim.inspect(client.config.settings.yaml.schemas), vim.log.levels.DEBUG)
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
        ['textDocument/publishDiagnostics'] = function(err, result, ctx)
          result.diagnostics = vim.tbl_filter(function(diagnostic)
            -- disable diagnostics for missing property
            -- these could be defined in the defaults (for pipeline.yaml)
            -- or as environment variables (for config.yaml)
            if diagnostic.message:match('Missing property ') then
              return false
            end

            return true
          end, result.diagnostics)

          vim.lsp.handlers['textDocument/publishDiagnostics'](err, result, ctx)
        end,
      },
    },
  }
  require('lspconfig').kpops.setup(config.yamlls)
end

return M
