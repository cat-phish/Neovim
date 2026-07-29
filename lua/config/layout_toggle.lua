-- Shared layout toggle logic for fyler + aerial
local M = {}

-- Helper to reliably find sidebars even if filetype is slow to load
local function get_sidebars()
  local has_fyler, fyler_win = false, nil
  local has_aerial, aerial_win = false, nil

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    local name = vim.api.nvim_buf_get_name(buf)

    if ft == 'fyler' or name:match 'fyler' then
      has_fyler, fyler_win = true, win
    end
    if ft == 'aerial' or name:match 'aerial' then
      has_aerial, aerial_win = true, win
    end
  end
  return has_fyler, fyler_win, has_aerial, aerial_win
end

M.open_layout = function()
  local layout_config = require 'config.layout'
  local fyler_width = math.floor(vim.o.columns * layout_config.fyler_width_percent)
  local aerial_width = math.floor(vim.o.columns * layout_config.aerial_width_percent)

  local ead_state = vim.o.equalalways
  vim.o.equalalways = false

  -- 1. SAVE YOUR EXACT MAIN WINDOW LOCATION
  local main_win = vim.api.nvim_get_current_win()

  -- 2. Open Fyler
  require('fyler').open { kind = 'split_left_most' }

  -- 3. RETURN FOCUS IMMEDIATELY TO MAIN WINDOW
  if vim.api.nvim_win_is_valid(main_win) then vim.api.nvim_set_current_win(main_win) end

  -- 4. Open Aerial (It now correctly attaches to your code buffer!)
  vim.cmd 'AerialOpen! right'

  -- 5. RETURN FOCUS AGAIN (Just in case Aerial stole it)
  if vim.api.nvim_win_is_valid(main_win) then vim.api.nvim_set_current_win(main_win) end

  -- 6. Lock widths cleanly
  vim.schedule(function()
    local _, f_win, _, a_win = get_sidebars()

    if f_win and vim.api.nvim_win_is_valid(f_win) then
      vim.wo[f_win].winfixwidth = false
      vim.api.nvim_win_set_width(f_win, fyler_width)
      vim.wo[f_win].winfixwidth = true
    end

    if a_win and vim.api.nvim_win_is_valid(a_win) then
      vim.wo[a_win].winfixwidth = false
      vim.api.nvim_win_set_width(a_win, aerial_width)
      vim.wo[a_win].winfixwidth = true
    end

    vim.o.equalalways = ead_state
    vim.cmd 'wincmd ='
    vim.cmd 'redrawtabline'
  end)
end

function M.close_layout()
  local has_fyler, fyler_win, has_aerial, aerial_win = get_sidebars()

  local ead_state = vim.o.equalalways
  vim.o.equalalways = false

  if has_fyler and vim.api.nvim_win_is_valid(fyler_win) then vim.api.nvim_win_close(fyler_win, false) end
  if has_aerial and vim.api.nvim_win_is_valid(aerial_win) then vim.api.nvim_win_close(aerial_win, false) end

  vim.schedule(function()
    vim.o.equalalways = ead_state
    vim.cmd 'wincmd ='
    vim.cmd 'redrawtabline'
  end)
end

function M.toggle_layout()
  local has_fyler, _, has_aerial, _ = get_sidebars()
  if has_fyler or has_aerial then
    M.close_layout()
  else
    M.open_layout()
  end
end

return M
