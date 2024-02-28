---@class DefaultConfig
local config = {
  settings = {
    yaml = {
      editor = { formatOnType = true },
      ---@type table<string, string | string[]>
      schemas = {
        ['https://bakdata.github.io/kpops/3.0/schema/pipeline.json'] = {
          'pipeline.yaml',
          'pipeline_*.yaml',
        },
        ['https://bakdata.github.io/kpops/3.0/schema/defaults.json'] = {
          'defaults.yaml',
          'defaults_*.yaml',
        },
        ['https://bakdata.github.io/kpops/3.0/schema/config.json'] = {
          'config.yaml',
          'config_*.yaml',
        },
      },
    },
    kpops = {
      generate_schema = true,
    },
  },
}
return config
