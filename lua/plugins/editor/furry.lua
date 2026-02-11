return {
  'litvinov-git/furry.nvim',
  dependencies = { 'nvim-mini/mini.fuzzy' },
  config = function()
    require('furry').setup {
      -- Defaults:
      -- highlight_matches = true,
      -- highlight_current = true,
      -- max_score = 1800,
      -- progressive = true,
      -- on_empty = "dump",
      -- on_space = "repeat_last",
      -- on_change = "dump",
      -- on_buf_enter = "repeat_last",
      vim.keymap.set('n', '<leader>sf', ':Furry<CR>'),
    }
    -- vim.keymap.set("n", "sa", ":FurryPrev<CR>")
    -- vim.keymap.set("n", "sd", ":FurryNext<CR>")
  end,
}
