# kpops.nvim

Neovim plugin for integrating [KPOps](https://github.com/bakdata/kpops) using [YAML language server](https://github.com/redhat-developer/yaml-language-server).

<img width="1078" alt="demo" src="https://github.com/disrupted/kpops.nvim/assets/4771462/53888675-d0f1-4297-8441-4d42887fafef">

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
