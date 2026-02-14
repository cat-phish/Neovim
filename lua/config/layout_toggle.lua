-- Shared layout toggle logic for fyler + aerial
-- This ensures consistent behavior between keymap and autocmd

local M = {}

-- Open both fyler (left) and aerial (right) with proper sizing
function M.open_layout()
  -- Close toggleterm if it's open before opening fyler/aerial
  if vim.g.toggleterm_window and vim.api.nvim_win_is_valid(vim.g.toggleterm_window) then
    vim.api.nvim_win_close(vim.g.toggleterm_window, false)
    vim.g.toggleterm_window = nil
  end
  
  -- Open both: fyler on left, aerial on right
  require('fyler').open { kind = 'split_left_most' }
  
  -- Give a moment for fyler to settle, then open aerial on the far right
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
    local aerial_width = math.floor(total_width * layout_config.aerial_width_percent)
    
    -- Move to the main window (not fyler)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if win ~= fyler_win then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
    
    vim.cmd('AerialOpen right')
    
    -- Set both widths explicitly after both windows are open
    -- Use defer_fn instead of schedule to give Aerial time to initialize (mimics startup timing)
    vim.defer_fn(function()
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
      if fyler_win and vim.api.nvim_win_is_valid(fyler_win) then
        vim.wo[fyler_win].winfixwidth = false
        vim.api.nvim_win_set_width(fyler_win, fyler_width)
        vim.wo[fyler_win].winfixwidth = true
      end
      if aerial_win and vim.api.nvim_win_is_valid(aerial_win) then
        vim.api.nvim_win_set_width(aerial_win, aerial_width)
        vim.wo[aerial_win].winfixwidth = true
      end
      
      -- Add an extra schedule to ensure fyler width sticks
      vim.schedule(function()
        if fyler_win and vim.api.nvim_win_is_valid(fyler_win) then
          vim.wo[fyler_win].winfixwidth = false
          vim.api.nvim_win_set_width(fyler_win, fyler_width)
          vim.wo[fyler_win].winfixwidth = true
        end
        
        -- Focus the main window (not fyler or aerial)
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.bo[buf].filetype
          if ft ~= 'fyler' and ft ~= 'aerial' then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end)
    end, 20)
  end)
end

-- Close both fyler and aerial, restore remaining window widths
function M.close_layout()
  -- Helper function to check if a window with a specific filetype exists
  local function has_filetype_window(filetype)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      if ft == filetype then return true, win end
    end
    return false, nil
  end

  local has_fyler, fyler_win = has_filetype_window 'fyler'
  local has_aerial, aerial_win = has_filetype_window 'aerial'

  -- Close fyler if open
  if has_fyler then require('fyler').close() end
  -- Close aerial if open
  if has_aerial then vim.api.nvim_win_close(aerial_win, false) end
  
  -- After closing, restore any remaining window widths
  vim.schedule(function()
    local layout_config = require('config.layout')
    local fyler_width = math.floor(vim.o.columns * layout_config.fyler_width_percent)
    local aerial_width = math.floor(vim.o.columns * layout_config.aerial_width_percent)
    
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      if ft == 'fyler' then
        vim.wo[win].winfixwidth = false
        vim.api.nvim_win_set_width(win, fyler_width)
        vim.wo[win].winfixwidth = true
      elseif ft == 'aerial' then
        vim.api.nvim_win_set_width(win, aerial_width)
        vim.wo[win].winfixwidth = true
      end
    end
  end)
end

-- Toggle layout: if either is open, close both; otherwise open both
function M.toggle_layout()
  -- Helper function to check if a window with a specific filetype exists
  local function has_filetype_window(filetype)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      if ft == filetype then return true, win end
    end
    return false, nil
  end

  -- Check if fyler or aerial windows are open
  local has_fyler = has_filetype_window 'fyler'
  local has_aerial = has_filetype_window 'aerial'

  -- If either or both are open, close both; otherwise open both
  if has_fyler or has_aerial then
    M.close_layout()
  else
    M.open_layout()
  end
end

return M
