if not vim.fn.executable('kpops') == 1 then
  return
end
vim.filetype.add({
  pattern = {
    ['pipeline[_%w]*%.yaml'] = 'yaml.kpops',
    ['defaults[_%w]*%.yaml'] = 'yaml.kpops',
    ['config[_%w]*%.yaml'] = 'yaml.kpops',
  },
})
