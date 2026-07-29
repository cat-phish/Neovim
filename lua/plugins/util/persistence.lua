-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.

local function close_both()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    local name = vim.api.nvim_buf_get_name(buf)

    if ft == 'fyler' or ft == 'aerial' or name:match 'fyler' or name:match 'aerial' then pcall(vim.api.nvim_win_close, win, true) end
  end
end

local function restore_both()
  local ead_state = vim.o.equalalways
  vim.o.equalalways = false

  close_both()

  -- Clean up any directory buffers left over
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname ~= '' and vim.fn.isdirectory(bufname) == 1 then pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
    end
  end

  -- 1. SAVE MAIN TEXT WINDOW
  local main_win = vim.api.nvim_get_current_win()

  -- 2. Open Fyler
  require('fyler').open { kind = 'split_left_most' }

  -- 3. RETURN FOCUS TO TEXT WINDOW IMMEDIATELY
  if vim.api.nvim_win_is_valid(main_win) then vim.api.nvim_set_current_win(main_win) end

  -- Defer Aerial slightly so restored file buffers have time to start loading
  vim.defer_fn(function()
    -- 4. GUARANTEE FOCUS IS STILL ON TEXT WINDOW
    if vim.api.nvim_win_is_valid(main_win) then vim.api.nvim_set_current_win(main_win) end

    vim.cmd 'AerialOpen! right'

    -- 5. RETURN FOCUS ONCE MORE
    if vim.api.nvim_win_is_valid(main_win) then vim.api.nvim_set_current_win(main_win) end

    vim.schedule(function()
      local layout_config = require 'config.layout'
      local fyler_width = math.floor(vim.o.columns * layout_config.fyler_width_percent)
      local aerial_width = math.floor(vim.o.columns * layout_config.aerial_width_percent)

      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        local name = vim.api.nvim_buf_get_name(buf)

        if ft == 'fyler' or name:match 'fyler' then
          vim.wo[win].winfixwidth = false
          vim.api.nvim_win_set_width(win, fyler_width)
          vim.wo[win].winfixwidth = true
        elseif ft == 'aerial' or name:match 'aerial' then
          vim.wo[win].winfixwidth = false
          vim.api.nvim_win_set_width(win, aerial_width)
          vim.wo[win].winfixwidth = true
        end
      end

      vim.o.equalalways = ead_state
      vim.cmd 'wincmd ='
      vim.cmd 'redrawtabline'
    end)
  end, 50)
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
