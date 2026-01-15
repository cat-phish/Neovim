return {
  'brianhuster/live-preview.nvim',
  dependencies = {
    -- You can choose one of the following pickers
    -- 'nvim-telescope/telescope.nvim',
    -- 'ibhagwan/fzf-lua',
    -- 'echasnovski/mini.pick',
    'folke/snacks.nvim',
  },
  opts = {
    port = 5500,
    browser = 'chromium', -- Replace 'default' with your browser command
    dynamic_root = true, -- Useful for finding local images relative to the file
    sync_scroll = true,
    picker = 'snacks.picker',
  },
  keys = {
    {
      '<leader>um',
      ft = 'markdown',
      '<cmd>LivePreview start<cr>',
      desc = 'Markdown Preview',
    },
  },
}
