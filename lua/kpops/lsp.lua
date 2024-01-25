local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local schema = require('kpops.schema')

local M = {}

---@param conf table<string, any>
M.setup = function(conf)
  configs.kpops = {
    -- https://github.com/redhat-developer/yaml-language-server
    default_config = {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml' },
      root_dir = function(filename)
        if not schema.is_kpops_file(filename) then
          return nil -- not a KPOps project, abort LSP startup
        end

        local cwd = lspconfig.util.find_git_ancestor(filename) or vim.loop.cwd()
        return cwd
      end,
      on_attach = function(client, bufnr)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        schema.match_kpops_file(filename)
        local scope = assert(schema.match_kpops_file(filename))
        local schema_path = assert(schema.generate(scope))
        client.config.settings.yaml.schemas[schema_path] = {
          scope .. '.yaml',
          scope .. '_*.yaml',
        }
        vim.notify('reload KPOps schemas')
        vim.notify(vim.inspect(client.config.settings.yaml.schemas), vim.log.levels.DEBUG)
        client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
      end,
      single_file_support = false,
      settings = {
        -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
        redhat = { telemetry = { enabled = false } },
        yaml = {
          editor = { formatOnType = true },
          schemas = {
            --   ['pipeline.json'] = {
            --     'pipeline.yaml',
            --     'pipeline_*.yaml',
            --   },
            --   ['defaults.json'] = {
            --     'defaults.yaml',
            --     'defaults_*.yaml',
            --   },
            --   ['config.json'] = {
            --     'config.yaml',
            --     'config_*.yaml',
            --   },
          },
        },
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
