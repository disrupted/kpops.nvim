# kpops.nvim

Neovim plugin for integrating [KPOps](https://github.com/bakdata/kpops) using [YAML language server](https://github.com/redhat-developer/yaml-language-server).

## Installation

example using [Lazy](https://github.com/folke/lazy.nvim) plugin manager

```lua
{
    'disrupted/kpops.nvim',
    ft = 'yaml',
    config = true,
    dependencies = { 'neovim/nvim-lspconfig' }
}
```
