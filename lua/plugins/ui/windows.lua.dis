-- NOTE: causing issues with dap ui
return {
  -- 'anuvyklack/windows.nvim',
  -- dependencies = {
  --    'anuvyklack/middleclass',
  --    'anuvyklack/animation.nvim',
  -- },
  -- config = function()
  --    vim.o.winwidth = 5
  --    vim.o.winminwidth = 5
  --    vim.o.equalalways = false
  --    require('windows').setup()
  --
  --    -- Key mappings for Windows.nvim Window Maximizer
  --    vim.keymap.set('n', '<leader>wm', '<cmd>WindowsMaximize<CR>', { desc = 'Maximize window' })
  --    vim.keymap.set('n', '<leader>wh', '<cmd>WindowsMaximizeHorizontally<CR>', { desc = 'Maximize window (H)' })
  --    vim.keymap.set('n', '<leader>wv', '<cmd>WindowsMaximizeVertically<CR>', { desc = 'Maximize window (V)' })
  --    vim.keymap.set('n', '<leader>w=', '<cmd>WindowsEqualize<CR>', { desc = 'Equalize windows' })
  -- end,
  'anuvyklack/windows.nvim',
  dependencies = {
    'anuvyklack/middleclass',
    'anuvyklack/animation.nvim',
  },
  config = function()
    require('windows').setup {
      autowidth = { --		       |windows.autowidth|
        enable = true,
        winwidth = 0.75, --		        |windows.winwidth|
        filetype = { --	      |windows.autowidth.filetype|
          help = 2,
        },
      },
      ignore = { --			  |windows.ignore|
        buftype = { 'quickfix' },
        filetype = { 'NvimTree', 'neo-tree', 'undotree', 'gundo' },
      },
      animation = {
        enable = true,
        duration = 100,
        fps = 120,
        easing = 'in_out_sine',
      },
    }

    -- Key mappings for Windows.nvim Window Maximizer
    vim.keymap.set('n', '<leader>wm', '<cmd>WindowsMaximize<CR>', { desc = 'Maximize window' })
    vim.keymap.set('n', '<leader>wh', '<cmd>WindowsMaximizeHorizontally<CR>', { desc = 'Maximize window (H)' })
    vim.keymap.set('n', '<leader>wv', '<cmd>WindowsMaximizeVertically<CR>', { desc = 'Maximize window (V)' })
    vim.keymap.set('n', '<leader>w=', '<cmd>WindowsEqualize<CR>', { desc = 'Equalize windows' })
  end,
}
