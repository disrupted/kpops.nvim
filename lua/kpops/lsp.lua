local kpops = require('kpops.cli')
local utils = require('kpops.utils')
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

local M = {}

local function match_kpops_file(filename)
  local basename = assert(vim.fs.basename(filename))

  if basename:match('^pipeline[_%w]*.yaml$') then
    return 'pipeline'
  end
  if basename:match('^defaults[_%w]*.yaml$') then
    return 'defaults'
  end
  if basename:match('^config[_%w]*.yaml$') then
    return 'config'
  end
  return nil
end

local function is_kpops_file(filename)
  return match_kpops_file(filename) ~= nil
end

local function generate_schema(scope)
  if scope == 'defaults' then
    local kpops_version = kpops.version()
    local major, minor, patch = unpack(kpops_version)
    if major < 3 then
      return
    end
  end

  local schema = kpops.schema(scope)
  if schema ~= nil then
    local basename = string.format('kpops_schema_%s.json', scope)
    local schema_path = utils.write_tmpfile(basename, schema)
    return schema_path
  end
end

M.setup = function(conf)
  configs.kpops = {
    -- https://github.com/redhat-developer/yaml-language-server
    default_config = {
      cmd = { 'yaml-language-server', '--stdio' },
      filetypes = { 'yaml' },
      root_dir = function(filename)
        if not is_kpops_file(filename) then
          return nil -- not a KPOps project, abort LSP startup
        end

        local cwd = lspconfig.util.find_git_ancestor(filename) or vim.loop.cwd()
        return cwd
      end,
      on_attach = function(client, bufnr)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local scope = assert(match_kpops_file(filename))
        local schema_path = assert(generate_schema(scope))
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
