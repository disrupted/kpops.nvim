local kpops = require('kpops.consts').KPOPS:lower()
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config[kpops] = {
  maintainers = { 'disrupted' },
  install_info = {
    url = 'https://github.com/disrupted/tree-sitter-kpops',
    files = { 'src/parser.c' },
    branch = 'main',
  },
}
require('nvim-treesitter.install').ensure_installed_sync(kpops)
