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
    { '<Home>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<End>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
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
      always_show_bufferline = true,
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
        {
          filetype = 'fyler',
          text = 'Explorer',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
    },
  },
  -- TODO: figure out if this is necessary
  config = function(_, opts)
    require('bufferline').setup(opts)
    options = {
      -- Other options...

      --- @param buf_id number
      --- @param click_type string
      navigation_click_handler = function(buf_id, click_type)
        -- Only handle left clicks for switching
        if click_type == 'left' then
          local current_win = vim.api.nvim_get_current_win()

          -- Check if the current window is fixed
          if vim.wo[current_win].winfixbuf then
            -- Look for a window that isn't fixed
            local target_win = nil
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if not vim.wo[win].winfixbuf then
                target_win = win
                break
              end
            end

            if target_win then
              vim.api.nvim_set_current_win(target_win)
              vim.api.nvim_win_set_buf(target_win, buf_id)
            else
              -- Optional: If all windows are fixed, create a new split
              vim.cmd 'vsplit'
              vim.api.nvim_win_set_buf(0, buf_id)
            end
          else
            -- If current window is NOT fixed, just switch normally
            vim.api.nvim_win_set_buf(current_win, buf_id)
          end
        end
      end,
    }
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd('BufAdd', {
      callback = function()
        vim.schedule(function() pcall(nvim_bufferline) end)
      end,
    })
  end,
}
