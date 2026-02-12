return {
  'cat-phish/bufferline-manager.nvim',
  -- dir = '~/source/nvim-plugins/bufferline-manager.nvim',
  dependencies = {
    'akinsho/bufferline.nvim',
  },
  opts = {
    -- Optional: customize configuration
    width = 80,
    height = 20,
    border = 'rounded',
    title = ' Bufferline Manager ',
    show_full_path = false,
    show_numbers = true,
    smart_path = true,
    use_relative = nil, -- nil = inherit user setting, true = force relative, false = force absolute
    confirm_delete = false,
    confirm_save = true,
    auto_save_on_exit_insert = false,
    keymaps = {
      delete = 'dd',
      move_down = '<A-j>',
      move_up = '<A-k>',
      jump = '<CR>',
      close = { 'q', '<Esc>' },
      refresh = 'r',
    },
  },
  keys = {
    { '<leader>bm', '<cmd>BufferlineManager<cr>', desc = 'Buffer Manager' },
  },
}
