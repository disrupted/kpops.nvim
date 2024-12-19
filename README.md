# kpops.nvim

Neovim plugin for integrating [KPOps](https://github.com/bakdata/kpops)

<img width="1078" alt="demo" src="https://github.com/disrupted/kpops.nvim/assets/4771462/53888675-d0f1-4297-8441-4d42887fafef">

## Installation

example using [Lazy](https://github.com/folke/lazy.nvim) plugin manager

```lua
{
    'disrupted/kpops.nvim',
    cmd = 'KPOps',
    ft = 'yaml.kpops',
    dependencies = {
        'neovim/nvim-lspconfig',
        'gregorias/coop.nvim',
    },
    ---@module 'kpops.config'
    ---@type kpops.Opts
    opts = {},
}
```

Default Configuration (passed as `opts`)

```lua
{
    kpops = {
        generate_schema = true,
    }
}
```

## Features

- LSP (using [YAML language server](https://github.com/redhat-developer/yaml-language-server))
  - schema validation
  - autocompletion
  - custom diagnostics handler
    > disable diagnostics for missing property
    > these could be defined in the defaults (for pipeline.yaml)
    > or as environment variables (for config.yaml)
- automatic schema generation in the background for all KPOps user files (pipeline.yaml, defaults.yaml, config.yaml)
- CLI integration as Ex commands, e.g. `:KPOps generate`
