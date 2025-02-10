-- This is what powers LazyVim's fancy-looking
-- tabs, which include filetype icons and close buttons.
return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  dependencies = {
    { 'echasnovski/mini.bufremove', version = false, opts = {} },
  },
  keys = {
    { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Buffer Pin' },
    { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    { '<leader>bO', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
    { '<leader>bR', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
    { '<leader>bL', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
    { ';', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { "'", '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '<leader>b>', '<cmd>BufferLineMoveNext<cr>', desc = 'Move Buffer Right' },
    { '<leader>b<', '<cmd>BufferLineMovePrev<cr>', desc = 'Move Buffer Left' },
    { '<C->>', '<cmd>BufferLineMoveNext<cr>', desc = 'Move Buffer Right' },
    { '<C-lt>', '<cmd>BufferLineMovePrev<cr>', desc = 'Move Buffer Left' },
  },
  opts = {
    options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
        -- stylua: ignore
        right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
      -- BUG: this diagnostic line is causing an issue
      -- diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Neo-tree',
          highlight = 'Directory',
          text_align = 'left',
        },
        {
          filetype = 'snacks_layout_box',
          -- text = 'Explorer',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
    },
  },
  -- TODO: figure out if this is necessary
  -- config = function(_, opts)
  -- 	require("bufferline").setup(opts)
  -- 	-- Fix bufferline when restoring a session
  -- 	vim.api.nvim_create_autocmd("BufAdd", {
  -- 		callback = function()
  -- 			vim.schedule(function()
  -- 				pcall(nvim_bufferline)
  -- 			end)
  -- 		end,
  -- 	})
  -- end,
}
