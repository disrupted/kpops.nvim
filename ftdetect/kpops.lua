local kpops = require('kpops.cli')
if not kpops.is_installed() then
  return
end
vim.filetype.add({
  pattern = {
    ['pipeline_?.*%.yaml'] = 'yaml.kpops',
    ['defaults_?.*%.yaml'] = 'yaml.kpops',
    ['config_?.*%.yaml'] = 'yaml.kpops',
  },
})
