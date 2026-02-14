-- TODO: go through whole config and make sure to add all mappings as comments here

local Util = require 'config.utils'

--#####################
--####  Navigation ####
--#####################

-- Function to jump to a global mark's buffer but at last cursor position
local function jump_to_mark_buffer_last_position()
  -- Get the mark character from user input
  local mark = vim.fn.getchar()
  local mark_char = vim.fn.nr2char(mark)

  -- Only work with uppercase letters (global marks are A-Z)
  if not mark_char:match '[A-Z]' then
    vim.notify('Please use an uppercase letter (A-Z) for global marks', vim.log.levels.WARN)
    return
  end

  -- Get mark information
  local mark_pos = vim.fn.getpos("'" .. mark_char)

  -- mark_pos structure: [bufnum, lnum, col, off]
  local bufnum = mark_pos[1]

  if bufnum == 0 then
    vim.notify("Mark '" .. mark_char .. "' is not set", vim.log.levels.WARN)
    return
  end

  -- Jump to the buffer - nvim automatically restores the last cursor position
  vim.cmd('buffer ' .. bufnum)

  -- Center the screen
  vim.cmd 'normal! zz'
end

-- Set up the keymap
vim.keymap.set('n', "<leader>'", jump_to_mark_buffer_last_position, {
  desc = "Jump to global mark's buffer at last cursor position",
  noremap = true,
  silent = true,
})

-- NOTE: Beginning and End of Line
local function jump_to_line_start()
  local col = vim.fn.col '.'
  local first_non_blank = vim.fn.indent(vim.fn.line '.') + 1
  if col == first_non_blank then
    return '0' -- Jump to the beginning of the line
  else
    return '^' -- Jump to the first non-blank character
  end
end
vim.keymap.set({ 'n', 'v', 'o' }, 'H', function() return jump_to_line_start() end, { noremap = true, expr = true, desc = 'Beginning of line' })
vim.keymap.set({ 'n', 'v', 'o' }, 'L', '$', { noremap = true, desc = 'End of Line' })

-- NOTE: better up/down
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- NOTE: Saner behavior of n and N
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

--NOTE:
--##################
--####  Editing ####
--##################

-- NOTE: Save File with <C-s>
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

-- NOTE: Better Indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- NOTE: Don't Yank with `dd` on Empty Line
vim.keymap.set('n', 'dd', function()
  if vim.api.nvim_get_current_line():find '^%s*$' then return '"_dd' end
  return 'dd'
end, { expr = true })

-- NOTE: Delete with C-l in insert to mirror default C-h backspace
vim.keymap.set('i', '<C-l>', '<Del>', { desc = 'Delete' })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })
vim.keymap.set('n', '<A-h>', '<<', { desc = 'De-Indent' })
vim.keymap.set('n', '<A-l>', '>>', { desc = 'Indent' })
vim.keymap.set('v', '<A-h>', '<gv', { desc = 'De-Indent' })
vim.keymap.set('v', '<A-l>', '>gv', { desc = 'Indent' })
-- The mappings below are disabled because escaping to Normal mode and
-- pressing j or k too quickly can cause lines to shift. Also, it's
-- unnecessary to use these mappings when the above mappings are available.
-- vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
-- vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })

-- Easier redo
-- vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Quick Macro
vim.keymap.set('n', 'Q', '@q', { desc = 'Quick Macro' })

-- Remap tab in cmdline to complete (not working, but it does disable tab insertion)
vim.keymap.set('c', '<Tab>', '<C-n>', { noremap = true })

-- Yanking
vim.keymap.set('v', '<leader>yc', '"+y', { desc = 'Yank to Clipboard' })
vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Yank Line to Clipboard' })
vim.keymap.set('n', '<leader>yb', '<cmd>%y+<cr>', { desc = 'Yank Buffer to Clipboard' })
vim.keymap.set('n', '<leader>yp', ":let @+=expand('%:.')<cr>", { desc = 'Yank relative path' })
vim.keymap.set('n', '<leader>yP', ':let @+=@%<cr>', { desc = 'Yank absolute path' })

-- Auto-Pairs
-- NOTE: this mapping is dependent on plugins/editor/mini-pairs.lua
vim.keymap.set('n', '<leader>Op', function()
  vim.g.minipairs_disable = not vim.g.minipairs_disable
  if vim.g.minipairs_disable then
    Util.warn('Disabled auto-pairs', { title = 'Option' })
  else
    Util.info('Enabled auto-pairs', { title = 'Option' })
  end
end, { desc = 'Toggle Auto-Pairs' })

-- Toggle Spelling
vim.keymap.set('n', '<leader>Os', function()
  vim.wo.spell = not vim.wo.spell
  if vim.wo.spell then
    Util.info('Enabled spelling', { title = 'Option' })
  else
    Util.warn('Disabled spelling', { title = 'Option' })
  end
end, { desc = 'Toggle Spelling' })

--#################
--####  Coding ####
--#################

-- Quickfix
vim.keymap.set('n', '<leader>dl', '<cmd>lopen<cr>', { desc = 'Location List' })
vim.keymap.set('n', '<leader>dq', '<cmd>copen<cr>', { desc = 'Quickfix List' })
vim.keymap.set('n', '[q', vim.cmd.cprev, { desc = 'Previous quickfix' })
vim.keymap.set('n', ']q', vim.cmd.cnext, { desc = 'Next quickfix' })

-- Copilot Toggle
vim.keymap.set('n', '<leader>cpe', '<cmd>Copilot enable<CR>', { desc = 'Copilot Suggestions Enable' })
vim.keymap.set('n', '<leader>cpd', '<cmd>Copilot disable<CR>', { desc = 'Copilot Suggestions Disable' })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function() go { severity = severity } end
end
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- insert new commented line from current
vim.keymap.set('i', '<C-CR>', function()
  -- 1. Get current indentation
  local line = vim.api.nvim_get_current_line()
  local indent = line:match '^%s*'
  -- get the comment prefix
  local cms = vim.bo.commentstring
  if cms == '' then cms = '# %s' end -- fallback
  -- extract everything before "%s" and trim trailing whitespace
  local prefix = cms:gsub('%%s.*', '')
  -- construct the new line: indent + comment prefix
  local new_line = indent .. prefix
  -- insert the line below the current one
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, false, { new_line })
  -- move cursor to the end of the new line and stay in insert mode
  vim.api.nvim_win_set_cursor(0, { row + 1, #new_line })
  vim.cmd 'startinsert!'
end, { desc = 'New indented commented line' })

-- toggle diagnostics

-- toggle options
-- TODO: fix these Util calls
-- vim.keymap.set("n", "<leader>Ef", function()
-- 	Util.format.toggle()
-- end, { desc = "Toggle auto format (global)" })
-- vim.keymap.set("n", "<leader>EF", function()
-- 	Util.format.toggle(true)
-- end, { desc = "Toggle auto format (buffer)" })
-- vim.keymap.set("n", "<leader>Es", function()
-- 	Util.toggle("spell")
-- end, { desc = "Toggle Spelling" })
-- vim.keymap.set("n", "<leader>Ew", function()
-- 	Util.toggle("wrap")
-- end, { desc = "Toggle Word Wrap" })

-- vim.keymap.set("n", "<leader>Ed", function()
-- 	Util.toggle.diagnostics()
-- end, { desc = "Toggle Diagnostics" })
-- local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
-- vim.keymap.set("n", "<leader>Ec", function()
-- 	Util.toggle("conceallevel", false, { 0, conceallevel })
-- end, { desc = "Toggle Conceal" })
-- if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
-- 	vim.keymap.set("n", "<leader>Eh", function()
-- 		Util.toggle.inlay_hints()
-- 	end,>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
-- { "'", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
-- { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
-- { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },

-- Last Buffer
vim.keymap.set('n', '<leader><tab>', '<cmd>e #<cr>', { desc = 'Last buffer' })

--###################
--####  Windows  ####
--###################

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Switch to Last Window
vim.keymap.set('n', '<leader>ww', '<C-W>p', { desc = 'Last window', remap = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })

-- Window Splitting
vim.keymap.set('n', '<leader>w-', '<C-W>s', { desc = 'Split below', remap = true })
vim.keymap.set('n', '<leader>w|', '<C-W>v', { desc = 'Split right', remap = true })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Toggle Floating Window Focus
vim.keymap.set('n', '<leader>wf', function()
  local found_float = false
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    -- Check if window is floating and focusable
    if config.relative ~= '' and config.focusable then
      vim.api.nvim_set_current_win(win)
      found_float = true
      break
    end
  end

  if not found_float then print 'No floating window found' end
end, { desc = 'Window: Focus floating window' })

-- Zen Mode
-- vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>', { desc = 'Zen Mode' })

--##################
--####  Search  ####
--##################

--#######################
--####  Diagnostics  ####
--#######################

--###############
--####  Git  ####
--###############

-- lazygit
-- TODO: fix this Util call
-- vim.keymap.set("n", "<leader>gg", function()
-- 	Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })
-- end, { desc = "Lazygit (root dir)" })
-- vim.keymap.set("n", "<leader>gG", function()
-- 	Util.terminal({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false })
-- end, { desc = "Lazygit (cwd)" })

--##############
--####  UI  ####
--##############

-- Toggle Fyler and Aerial Together
vim.keymap.set('n', '<leader>z', function()
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
  local has_fyler, fyler_win = has_filetype_window 'fyler'
  local has_aerial, aerial_win = has_filetype_window 'aerial'

  -- If either or both are open, close both
  if has_fyler or has_aerial then
    -- Close fyler if open
    if has_fyler then require('fyler').close() end
    -- Close aerial if open
    if has_aerial then vim.api.nvim_win_close(aerial_win, false) end
  else
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
        end)
      end)
    end)
  end
end, { desc = 'Explorer & Outline Toggle' })

-- Zen Mode
-- vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>', { desc = 'Zen Mode' })

-- quit
-- vim.keymap.set('n', '<leader>Sq', '<cmd>qa<cr>', { desc = 'Quit All' })

-- Flag to track temporary toggle state
local temp_relnu_toggle = false

-- Permanent Toggle Relative Line Numbers
vim.keymap.set('n', '<leader>On', function()
  if vim.opt_local.relativenumber:get() then
    -- Switch to static line numbers
    vim.opt_local.relativenumber = false
    Util.info('Switched to absolute line numbers', { title = 'Option' })
  else
    -- Switch to relative line numbers
    vim.opt_local.relativenumber = true
    Util.info('Switched to relative line numbers', { title = 'Option' })
  end
end, { desc = 'Toggle Relative/Absolute Line Numbers' })

-- Temporary Toggle Relative Line Numbers
vim.keymap.set('n', '<leader>n', function()
  if vim.opt_local.relativenumber:get() then
    -- Switch to static line numbers
    vim.opt_local.relativenumber = false
    temp_relnu_toggle = true
    -- Util.info('Temporarily switched to absolute line numbers', { title = 'Option' })
  else
    -- Switch to relative line numbers
    vim.opt_local.relativenumber = true
    temp_relnu_toggle = false
    -- Util.info('Switched to relative line numbers', { title = 'Option' })
  end
end, { desc = 'Temp Toggle Rel/Abs Line Numbers' })
-- Autocommand to re-enable relative line numbers if they were temporarily turned off
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
  callback = function()
    if temp_relnu_toggle and not vim.opt_local.relativenumber:get() then
      vim.opt_local.relativenumber = true
      -- Util.info('Re-enabled relative line numbers', { title = 'Option' })
      temp_relnu_toggle = false
    end
  end,
})
-- Clear Rel Numbers and Highlight with Esc
vim.keymap.set({ 'n' }, '<esc>', function()
  vim.cmd 'noh'
  if vim.fn.mode() == 'n' then
    if temp_relnu_toggle and not vim.opt_local.relativenumber:get() then
      vim.opt_local.relativenumber = true
      temp_relnu_toggle = false
      -- Util.info('Re-enabled relative line numbers', { title = 'Option' })
    end
  end
  return '<esc>'
end, { expr = true, desc = 'Escape, clear hlsearch, and restore relativenumber' })

-- Toggle Line Number Visibility
vim.keymap.set('n', '<leader>ON', function()
  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    Util.warn('Disabled line numbers', { title = 'Option' })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    Util.info('Enabled line numbers', { title = 'Option' })
  end
end, { desc = 'Toggle Line Number Visibility' })

-- Toggle Word Wrap
vim.keymap.set('n', '<leader>Ow', function()
  vim.wo.wrap = not vim.wo.wrap
  local status = vim.wo.wrap and 'enabled' or 'disabled'
  Util.info('Word wrap ' .. status, { title = 'Option' })
end, { desc = 'Toggle Word Wrap' })

-- Biscuits Toggle
vim.keymap.set('n', '<leader>Ob', "<cmd>lua require('nvim-biscuits').toggle_biscuits()<CR>", { desc = 'Toggle Biscuits' })

-- highlights under cursor
vim.keymap.set('n', '<leader>ui', vim.show_pos, { desc = 'Inspect Pos' })

-- Add undo break-points
vim.keymap.set('i', ',', ',<c-g>u')
vim.keymap.set('i', '.', '.<c-g>u')
vim.keymap.set('i', ';', ';<c-g>u')

-- Clear search with <esc>
-- TODO: should this actually clear on insert mode? (case: searching and editing multiple instances. WOuld probably not need the escape command at the end if changed)
-- vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set('n', '<leader>ur', '<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>', { desc = 'Redraw / Clear hlsearch / Diff Update' })

--keywordprg
vim.keymap.set('n', '<leader>snK', '<cmd>norm! K<cr>', { desc = 'Keyword Under Cursor' })

-- Terminal Mappings
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide terminal' })
vim.keymap.set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

-- Added keys to config file
-- -- Markdown Preview
-- vim.keymap.set("n", "<leader>um", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown Preview" })
-- Second Monitor Settings Toggle
vim.keymap.set('n', '<leader>u2', function()
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.scrolloff = 999
  vim.opt.signcolumn = 'no'
  vim.opt.relativenumber = false
  vim.opt.number = false
end, { desc = 'Second Monitor Setting' })

--###############
--####  DAP  ####
--###############

-- DAP
-- NOTE: below mapped in plugins/dap/dap.lua
-- { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
-- { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },

-- DAP UI
-- NOTE: below mapped in plugins/dap/dap.lua
-- { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
-- { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
-- { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
-- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
-- { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
-- { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
-- { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
-- { "<leader>dj", function() require("dap").down() end, desc = "Down" },
-- { "<leader>dk", function() require("dap").up() end, desc = "Up" },
-- { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
-- { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
-- { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
-- { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
-- { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
-- { "<leader>ds", function() require("dap").session() end, desc = "Session" },
-- { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
-- { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },

--###################
--####  Fun Maps ####
--###################

--##################
--####  Plugins ####
--##################

-- Lazy
vim.keymap.set('n', '<leader>pl', '<cmd>Lazy<cr>', { desc = 'Lazy' })

--####################
--####  Utilities ####
--####################

--#################
--####  Hacks  ####
--#################

-- Disable accidental middle click pasting (for laptop trackpad in Linux)
-- will paste on 4 consecutive middle clicks
vim.keymap.set('n', '<MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('i', '<MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('v', '<MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('c', '<MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('n', '<2-MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('i', '<2-MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('v', '<2-MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('c', '<2-MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('n', '<3-MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('i', '<3-MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('v', '<3-MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })
vim.keymap.set('c', '<3-MiddleMouse>', '<Nop>', { desc = 'Disable Middle Click Paste' })

--#####################
--####  Test Maps  ####
--#####################a

-- Insert TODO comment
-- vim.keymap.set("n", "<leader>T", "xx<right>a<space>TODO:<space>", { desc = "Insert TODO comment" })
