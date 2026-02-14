-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.

-- Define helper functions to close Fyler and Aerial windows
local function close_fyler()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'fyler' then vim.api.nvim_win_close(win, true) end
  end
end

local function close_aerial()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'aerial' then vim.api.nvim_win_close(win, true) end
  end
end

local function close_both()
  close_fyler()
  close_aerial()
end

-- Helper to reopen fyler and aerial after session restore
local function restore_both()
  vim.schedule(function()
    -- First, close any fyler/aerial windows that might have been restored by the session
    close_both()

    -- Clean up any directory buffers left over
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
        local bufname = vim.api.nvim_buf_get_name(buf)
        -- Check if it's a directory buffer
        if bufname ~= '' and vim.fn.isdirectory(bufname) == 1 then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
      end
    end

    -- Reopen fyler on the left
    require('fyler').open { kind = 'split_left_most' }

    -- Schedule aerial to open on the right after fyler settles
    vim.schedule(function()
      -- Find the fyler window by filetype
      local fyler_win = nil
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'fyler' then
          fyler_win = win
          break
        end
      end

      -- Calculate intended widths
      local layout_config = require('config.layout')
      local total_width = vim.o.columns
      local fyler_width = math.floor(total_width * layout_config.fyler_width_percent)
      local aerial_width = layout_config.aerial_width_cols

      -- Move to the main window (not fyler)
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if win ~= fyler_win then
          vim.api.nvim_set_current_win(win)
          break
        end
      end

      vim.cmd 'AerialOpen right'

      -- Set both widths explicitly after both windows are open
      vim.schedule(function()
        -- Find aerial window
        local aerial_win = nil
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == 'aerial' then
            aerial_win = win
            break
          end
        end

        -- Set widths
        if fyler_win and vim.api.nvim_win_is_valid(fyler_win) then vim.api.nvim_win_set_width(fyler_win, fyler_width) end
        if aerial_win and vim.api.nvim_win_is_valid(aerial_win) then vim.api.nvim_win_set_width(aerial_win, aerial_width) end

        -- Move back to main editor window
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if ft ~= 'fyler' and ft ~= 'aerial' then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end)
    end)
  end)
end

return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {
    options = vim.opt.sessionoptions:get(),
    pre_save = close_both,
  },
  keys = {
    { '<leader>Sd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
    {
      '<leader>Sl',
      function()
        vim.g.restoring_session = true
        close_both()
        require('persistence').load { last = true }
      end,
      desc = 'Restore Last Session',
    },
    {
      '<leader>Sr',
      function()
        vim.g.restoring_session = true
        close_both()
        require('persistence').load()
      end,
      desc = 'Restore Session',
    },
    {
      '<leader>SS',
      function()
        vim.g.restoring_session = true
        close_both()
        require('persistence').select()
      end,
      desc = 'Select Session',
    },
  },
  config = function(_, opts)
    require('persistence').setup(opts)

    -- Auto-restore fyler and aerial after any session load
    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceLoadPost',
      callback = function() restore_both() end,
    })
  end,
}
