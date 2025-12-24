return {
  'marantz-dev/codeSeparator.nvim',
  -- This tells lazy.nvim to load the plugin specifically when these keys are pressed
  keys = {
    { '<leader>isb', ':BoxSeparator<CR>', desc = 'Box separator' },
    { '<leader>isl', ':LineSeparator<CR>', desc = 'Line separator' },
  },
  config = function()
    require('codeSeparator').setup {
      char = '#',
      padding = 2,
    }
  end,
}
