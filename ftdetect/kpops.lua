if not vim.fn.executable('kpops') == 1 then
  return
end
vim.filetype.add({
  pattern = {
    ['pipeline_?.*%.yaml'] = 'yaml.kpops',
    ['defaults_?.*%.yaml'] = 'yaml.kpops',
    ['config_?.*%.yaml'] = 'yaml.kpops',
  },
})
