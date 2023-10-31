local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

local M = {}

M.setup = function(conf)
  configs.kpops = {
    -- https://github.com/redhat-developer/yaml-language-server
    default_config = {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml' },
      root_dir = function(filename)
        if not filename:match('pipeline[_%w]*.yaml') and not filename:match('config.yaml') then
          return nil -- not a KPOps project, abort LSP startup
        end
        return lspconfig.util.find_git_ancestor(filename) or vim.loop.cwd()
      end,
      single_file_support = false,
      settings = {
        -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
        redhat = { telemetry = { enabled = false } },
        yaml = {
          editor = { formatOnType = true },
          schemas = {
            ['pipeline.json'] = {
              'pipeline.yaml',
              'pipeline_*.yaml',
            },
            ['https://github.com/bakdata/kpops/raw/main/docs/docs/schema/config.json'] = 'config.yaml',
          },
        },
      },
    },
    handlers = {
      ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        result.diagnostics = vim.tbl_filter(function(diagnostic)
          -- HACK: disable diagnostics for KPOps defaults (until a schema exists for it)
          -- otherwise it uses the schema for ansible defaults
          if result.uri:match('defaults[_%w]*.yaml') then
            return false
          end

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
  }
  lspconfig.kpops.setup(conf)
end

return M
