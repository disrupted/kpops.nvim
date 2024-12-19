local kpops = require('kpops.cli')
local schema = require('kpops.schema')
local utils = require('kpops.utils')
local KPOPS = require('kpops.consts').KPOPS

local M = {}

---@alias kpops_command 'generate' | 'version'
local commands = { 'generate', 'version' }

M.setup = function()
  vim.api.nvim_create_user_command(KPOPS, function(opts)
    require('kpops.commands').kpops(unpack(opts.fargs))
  end, { complete = require('kpops.commands').kpops_command_complete, nargs = '*' })
end

---@param command kpops_command
---@param ... string
M.kpops = function(command, ...)
  if not vim.list_contains(commands, command) then
    return kpops.arbitrary(command, ...)
  end
  return M[command]()
end

--- completion logic derived from Octo.nvim
---@param arg_lead string
---@param cmd string
M.kpops_command_complete = function(arg_lead, cmd)
  local parts = vim.split(vim.trim(cmd), ' ')

  local get_options = function(options)
    local valid_options = {}
    for _, option in pairs(options) do
      if string.sub(option, 1, #arg_lead) == arg_lead then
        table.insert(valid_options, option)
      end
    end
    return valid_options
  end

  if #parts == 1 then
    return commands
  elseif #parts == 2 and not commands[parts[2]] then
    return get_options(commands)
  end
end

M.generate = function()
  local fname = vim.api.nvim_buf_get_name(0)
  local scope = assert(schema.match_kpops_file(fname))
  if scope ~= schema.SCOPE.pipeline then
    utils.error(string.format('file is not a %s pipeline', KPOPS))
  end

  local pipeline = assert(kpops.generate(fname))

  -- create buffer and open floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('filetype', 'yaml.kpops', { buf = buf })
  vim.api.nvim_buf_set_name(buf, 'pipeline_generated.yaml')
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, vim.split(pipeline, '\n'))
  local win = vim.api.nvim_open_win(
    buf,
    true,
    { relative = 'win', width = 200, height = 300, bufpos = { 50, 50 } }
  )

  -- attach LSP
  local client = vim.lsp.get_clients({ name = 'kpops' })[1]
  vim.lsp.buf_attach_client(buf, client.id)
end

M.version = function()
  local version = kpops.version()
  utils.notify(string.format('%s %d.%d.%d', KPOPS, version.major, version.minor, version.patch))
end

return M
