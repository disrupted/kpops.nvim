local utils = require('kpops.utils')
local schema = require('kpops.schema')
local lsp = require('kpops.lsp')

local M = {}
local folder_to_watch = 'kpops/components'

---@type uv.uv_fs_event_t?
local watcher = nil

---@type uv.fs_event_start.callback
local function on_file_change(err, filename, events)
  if err then
    utils.error(('Error watching %s: %s'):format(filename, err))
    return
  end

  if vim.endswith(filename, '.py') and events.change then
    utils.notify(('%s changed: %s'):format(filename, vim.inspect(events)), vim.log.levels.DEBUG)
    M.refresh_schema()
  end
end

M.watch = function()
  watcher = assert(vim.uv.new_fs_event())
  local stat = vim.uv.fs_stat(folder_to_watch)
  if not stat or stat.type ~= 'directory' then
    utils.error(
      ('Error initializing watcher. %s is not a valid directory.'):format(folder_to_watch)
    )
    return
  end
  watcher:start(folder_to_watch, { recursive = true }, vim.schedule_wrap(on_file_change))
  utils.notify(('initialized watcher on %s'):format(folder_to_watch), vim.log.levels.DEBUG)
end

M.refresh_schema = function()
  local _, client = next(vim.lsp.get_clients({ name = 'kpops' }))
  if not client then
    M.close()
    return
  end

  require('coop').spawn(function()
    vim.iter({ schema.SCOPE.pipeline, schema.SCOPE.defaults }):each(function(scope)
      ---@type lsp_schema
      local schemas = client.config.settings.yaml.schemas
      if not lsp.schema_exists(schemas, scope) then
        return
      end
      assert(schema.generate(scope))
      utils.notify(string.format('reload %s schema', scope))
      client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
    end)
  end)
end

M.close = function()
  if watcher and not watcher:is_closing() then
    watcher:close()
    watcher = nil
  end
end

M.setup = function()
  local config = require('kpops.config').config
  if not watcher and config.kpops.generate_schema and config.kpops.watch then
    M.watch()
  end
end

return M
