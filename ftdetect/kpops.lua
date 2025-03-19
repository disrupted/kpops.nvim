if vim.fn.executable('kpops') ~= 1 then
  return
end
vim.filetype.add({
  filename = {
    ['pipeline.yaml'] = 'yaml.kpops',
    ['defaults.yaml'] = 'yaml.kpops',
    ['config.yaml'] = 'yaml.kpops',
  },
  pattern = {
    ['pipeline_[%w]*%.yaml'] = 'yaml.kpops',
    ['defaults_[%w]*%.yaml'] = 'yaml.kpops',
    ['config_[%w]*%.yaml'] = 'yaml.kpops',
  },
})
