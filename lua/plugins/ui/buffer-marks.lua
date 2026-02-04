return {
  'cat-phish/buffer-marks.nvim',
  -- dir = '~/source/nvim-plugins/buffer-marks.nvim',
  dev = true,
  enabled = false,
  event = 'VeryLazy',
  opts = {
    -- default config first
    save_marks = false,
    notify = true,
    notify_on_mark = true,
    notify_on_jump = false,
    keymaps = {
      --   mark = '<leader>m',
      -- jump = '<leader><space>',
      --   clear = '<leader>mc',
    },
  },
  -- call setup manually
  -- config = function()
  --   require('buffer-marks').setup({
  --     -- your config here
  --   })
  -- end,
}
