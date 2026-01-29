-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    options = vim.opt.sessionoptions:get(),
    -- Pre-save hook to close Fyler
    pre_save = function()
      -- Iterate through all windows and close Fyler
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'fyler' then vim.api.nvim_win_close(win, true) end
      end
    end,
  },
  keys = {
    { '<leader>Sd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
    { '<leader>Sl', function() require('persistence').load { last = true } end, desc = 'Restore Last Session' },
    { '<leader>Sr', function() require('persistence').load() end, desc = 'Restore Session' },
    { '<leader>SS', function() require('persistence').select() end, desc = 'Select Session' },
  },
}
