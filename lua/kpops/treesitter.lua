local kpops = require('kpops.consts').KPOPS:lower()
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.parsers')[kpops] = {
  maintainers = { 'disrupted' },
  ---@diagnostic disable-next-line: missing-fields
  install_info = {
    url = 'https://github.com/disrupted/tree-sitter-kpops',
    files = { 'src/parser.c' },
    branch = 'main',
  },
}
require('nvim-treesitter').install(kpops)
