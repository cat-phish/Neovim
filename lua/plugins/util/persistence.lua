-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.
-- Define a helper function to close Fyler windows
-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.

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

-- Helper to reopen fyler after session restore
local function restore_fyler()
  vim.schedule(function()
    -- Clean up any directory buffers left over
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
        local bufname = vim.api.nvim_buf_get_name(buf)
        -- Check if it's a directory buffer
        if bufname ~= '' and vim.fn.isdirectory(bufname) == 1 then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
      end
    end

    -- Reopen fyler in the left split
    require('fyler').open { kind = 'split_left' }
  end)
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
    {
      '<leader>Sl',
      function()
        close_fyler()
        require('persistence').load { last = true }
        -- restore_fyler()
      end,
      desc = 'Restore Last Session',
    },
    {
      '<leader>Sr',
      function()
        close_fyler()
        require('persistence').load()
        -- restore_fyler()
      end,
      desc = 'Restore Session',
    },
    {
      '<leader>SS',
      function()
        close_fyler()
        require('persistence').select()
        -- Don't call restore_fyler() here - let the autocmd handle it
      end,
      desc = 'Select Session',
    },
  },
  config = function(_, opts)
    require('persistence').setup(opts)

    -- Auto-restore fyler after any session load
    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceLoadPost',
      callback = function() restore_fyler() end,
    })
  end,
}
