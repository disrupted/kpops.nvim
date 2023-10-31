local setup = require('kpops').setup

describe('neovim plugin', function()
  it('work as expect', function()
    local result = setup()
    assert.is_true(result)
  end)
end)
