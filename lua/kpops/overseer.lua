local KPOPS = require('kpops.consts').KPOPS
local has_overseer, overseer = pcall(require, 'overseer')
if not has_overseer then
  return
end

overseer.register_template({
  name = ('%s generate'):format(KPOPS),
  tags = { overseer.TAG.BUILD },
  builder = function()
    local file = vim.fn.expand('%:p')
    return {
      cmd = { KPOPS:lower(), 'generate' },
      args = { file },
      components = {
        {
          'open_output',
          direction = 'float',
          focus = true,
          on_start = 'always',
          -- on_complete = 'failure',
        },
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'kpops' },
    callback = function(search)
      local fname = vim.fn.expand('%:t')
      local schema = require('kpops.schema')
      return schema.match_kpops_file(fname) == schema.SCOPE.pipeline
    end,
  },
})
