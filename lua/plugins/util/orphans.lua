return {
  'ZWindL/orphans.nvim',
  event = 'VeryLazy',
  cmd = 'Orphans',
  config = function()
    local Util = require 'config.utils'
    require('orphans').setup {
      ui = {
        date_format = '%Y-%m-%d', -- the format of the last commit date
      },
      analyzing_timeout = 2000, -- the timeout for the analysis for each plugin in ms
      ignored = { -- the list of plugins to be ignored
        'orphans.nvim', -- e.g. "orphans.nvim", due to the implementation problem, only plugin name is supported, more formats to be supported in the future release
      },
    }
    -- Warn about incompatility with nix installed plugins
    vim.api.nvim_create_autocmd('BufWinEnter', {
      pattern = '*',
      callback = function()
        if vim.bo.filetype == 'orphans' then
          Util.warn('Orphans.nvim does not work with plugins installed with nix', { title = 'Warning' })
        end
      end,
    })
  end,
}
