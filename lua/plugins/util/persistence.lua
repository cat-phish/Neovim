-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.
-- Define a helper function to close Fyler windows
local function close_fyler()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'fyler' then vim.api.nvim_win_close(win, true) end
  end
end

return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    options = vim.opt.sessionoptions:get(),
    pre_save = close_fyler,
  },
  keys = {
    { '<leader>Sd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },

    -- Restore Last Session (with close_fyler hook)
    {
      '<leader>Sl',
      function()
        close_fyler()
        require('persistence').load { last = true }
      end,
      desc = 'Restore Last Session',
    },

    -- Restore Session (with close_fyler hook)
    {
      '<leader>Sr',
      function()
        close_fyler()
        require('persistence').load()
      end,
      desc = 'Restore Session',
    },

    { '<leader>SS', function() require('persistence').select() end, desc = 'Select Session' },
  },
}
