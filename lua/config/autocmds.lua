-- TODO: go through whole config and add all autocommands from other files as comments
-- TODO: add autocommand for automatically disabling capslock on mode change or something

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('checktime', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then vim.cmd 'checktime' end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('last_loc', { clear = true }),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then return end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('close_with_q', { clear = true }),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
    'trouble',
    'markdown_floating_win',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- HACK: Extremely hacky way to make sure plugins like wtf close with <q>
-- Set a custom buffer variable when floating markdown window is created
-- and change the filetype to work with the close with <q> autocmd above.
-- WARNING: Will close all floating windows with the filetype 'markdown'
-- with <q>
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    local filetype = vim.bo.filetype

    if filetype == 'markdown' then
      -- Check if the buffer is a floating window
      local winid = vim.fn.win_getid()
      local config = vim.api.nvim_win_get_config(winid)
      if config.relative ~= '' then vim.bo.filetype = 'markdown_floating_win' end
    end
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('wrap_spell', { clear = true }),
  pattern = { 'gitcommit' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- wrap and check for spell in markdown filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('markdown_view', { clear = true }),
  pattern = { 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 80
    vim.opt_local.spell = true
    -- vim.opt_local.linebreak = true
    -- vim.opt_local.cursorcolumn = true
    vim.opt_local.colorcolumn = '80'
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = vim.api.nvim_create_augroup('json_conceal', { clear = true }),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function() vim.opt_local.conceallevel = 0 end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = vim.api.nvim_create_augroup('auto_create_dir', { clear = true }),
  callback = function(event)
    if event.match:match '^%w%w+://' then return end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- NOTE: deprecated in favor of temp/permanent toggling in the keymaps
-- -- Auto switch back to relative line numbers numerous events
-- vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter", "CmdlineLeave", "WinLeave" }, {
-- 	pattern = "*",
-- 	group = vim.api.nvim_create_augroup("reset_relnum_normal", { clear = true }),
-- 	callback = function()
-- 		if vim.o.nu then
-- 			vim.opt.relativenumber = true
-- 			-- vim.cmd("redraw")
-- 		end
-- 	end,
-- })

-- Switch to Normal mode when Neo-Tree window is entered
vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  pattern = 'fyler',
  group = vim.api.nvim_create_augroup('neotree_normal_mode', { clear = true }),
  command = 'stopinsert',
})

vim.api.nvim_create_autocmd('WinResized', {
  pattern = '*',
  callback = function()
    -- vim.opt.scrolloff = math.floor(vim.fn.winheight(0) / <uint>)
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    if vim.bo.filetype == 'help' then
      -- Move help window to the far right
      vim.cmd 'wincmd L'

      -- Optional but recommended
      vim.wo.winfixwidth = true
      vim.cmd 'vertical resize 80'
    end
  end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('no_auto_comment', {}),
  callback = function() vim.opt_local.formatoptions:remove { 'c', 'r', 'o' } end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('dotenv_ft', { clear = true }),
  pattern = { '.env', '.env.*' },
  callback = function() vim.bo.filetype = 'dosini' end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function() vim.opt_local.cursorline = true end,
})
-- show cursorline only in active window disable
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = 'active_cursorline',
  callback = function() vim.opt_local.cursorline = false end,
})

-- add to ctrl+o jump list when moving more than one line at a time
local function jump_with_mark(key)
  local count = vim.v.count1
  if count > 1 then return 'm`' .. count .. key end
  return key
end
vim.keymap.set('n', 'j', function() return jump_with_mark 'j' end, { expr = true, silent = true, desc = 'jump-aware down' })

vim.keymap.set('n', 'k', function() return jump_with_mark 'k' end, { expr = true, silent = true, desc = 'jump-aware up' })

-- TODO: this could probably replace vim-illuminate
-- -- ide like highlight when stopping cursor
-- vim.api.nvim_create_autocmd("CursorMoved", {
-- 	group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
-- 	desc = "Highlight references under cursor",
-- 	callback = function()
-- 		-- Only run if the cursor is not in insert mode
-- 		if vim.fn.mode() ~= "i" then
-- 			local clients = vim.lsp.get_clients({ bufnr = 0 })
-- 			local supports_highlight = false
-- 			for _, client in ipairs(clients) do
-- 				if client.server_capabilities.documentHighlightProvider then
-- 					supports_highlight = true
-- 					break -- Found a supporting client, no need to check others
-- 				end
-- 			end
--
-- 			-- 3. Proceed only if an LSP is active AND supports the feature
-- 			if supports_highlight then
-- 				vim.lsp.buf.clear_references()
-- 				vim.lsp.buf.document_highlight()
-- 			end
-- 		end
-- 	end,
-- })
-- vim.api.nvim_create_autocmd("CursorMovedI", {
-- 	group = "LspReferenceHighlight",
-- 	desc = "Clear highlights when entering insert mode",
-- 	callback = function()
-- 		vim.lsp.buf.clear_references()
-- 	end,
-- })

-- TODO: not working
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('WinFixBufRedirect', { clear = true }),
  callback = function(args)
    local win = vim.api.nvim_get_current_win()

    -- 1. Check if the window is fixed
    if not vim.wo[win].winfixbuf then return end

    -- 2. Check if the buffer we are entering is different from the one
    -- already 'locked' in this window.
    -- (We use a variable to store the 'rightful' buffer for this window)
    local fixed_buf = vim.t.last_fixed_buf or vim.api.nvim_win_get_buf(win)
    local target_buf = args.buf

    if target_buf ~= fixed_buf then
      -- The switch is illegal!
      -- First, restore the fixed window to its original buffer
      vim.api.nvim_win_set_buf(win, fixed_buf)

      -- Second, find a "safe" window to host the new buffer
      local target_win = nil
      for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if not vim.wo[w].winfixbuf and vim.api.nvim_win_get_config(w).relative == '' then
          target_win = w
          break
        end
      end

      if target_win then
        vim.api.nvim_set_current_win(target_win)
        vim.api.nvim_win_set_buf(target_win, target_buf)
      else
        -- Fallback: split if no safe window exists
        vim.cmd 'vsplit'
        vim.api.nvim_win_set_buf(0, target_buf)
      end
    end
  end,
})

-- Display time since last nvim config once per 8 hours
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = vim.fn.expand '~' .. '/.config/nvim/*',
  group = vim.api.nvim_create_augroup('nvim_config_check', { clear = true }),
  callback = function()
    local function convert_seconds(seconds)
      local units = { 'year', 'day', 'hour', 'minute', 'second' }
      local lengths = { 31536000, 86400, 3600, 60, 1 }
      local result = ''

      for i, unit in ipairs(units) do
        local val = math.floor(seconds / lengths[i])
        if val > 0 then
          result = result .. val .. ' ' .. unit .. (val > 1 and 's' or '') .. ' '
          seconds = seconds % lengths[i]
        end
      end

      return result
    end

    local function run_config_pulse_once_per_day()
      -- TODO: change stdpath to use config or state
      local time_file_path = vim.fn.stdpath 'data' .. '/config_pulse_last_run'
      local longest_stretch_file_path = vim.fn.stdpath 'data' .. '/config_pulse_longest_stretch'
      local last_run_time = ''
      local longest_stretch = ''

      -- Check if the time file exists before trying to read from it
      if vim.loop.fs_stat(time_file_path) then
        local time_file = io.open(time_file_path, 'r')
        if time_file then
          last_run_time = time_file:read '*a'
          time_file:close()
        end
      else
        -- If the time file does not exist, create it and write the current time
        local time_file = io.open(time_file_path, 'w')
        if time_file then
          time_file:write(tostring(os.time()))
          time_file:close()
        end
      end

      -- Check if the longest stretch file exists before trying to read from it
      if vim.loop.fs_stat(longest_stretch_file_path) then
        local longest_stretch_file = io.open(longest_stretch_file_path, 'r')
        if longest_stretch_file then
          longest_stretch = longest_stretch_file:read '*a'
          longest_stretch_file:close()
        end
      else
        -- If the longest stretch file does not exist, create it and write 0
        local longest_stretch_file = io.open(longest_stretch_file_path, 'w')
        if longest_stretch_file then
          longest_stretch_file:write '0'
          longest_stretch_file:close()
        end
      end

      local current_time = os.time()
      local time_since_last_edit = current_time - tonumber(last_run_time)

      -- Update the time file with the current time
      local time_file = io.open(time_file_path, 'w')
      if time_file then
        time_file:write(tostring(current_time))
        time_file:close()
      end

      if time_since_last_edit >= 3600 then
        local time_since_last_edit_str = 'Time since last edit: ' .. convert_seconds(time_since_last_edit)
        local high_score_str = 'High Score: ' .. convert_seconds(tonumber(longest_stretch))

        if time_since_last_edit > tonumber(longest_stretch) then
          local longest_stretch_file = io.open(longest_stretch_file_path, 'w')
          if longest_stretch_file then
            longest_stretch_file:write(tostring(time_since_last_edit))
            longest_stretch_file:close()
          end
          vim.notify('New High Score!\n' .. time_since_last_edit_str, vim.log.levels.INFO)
        else
          vim.notify(time_since_last_edit_str .. '\n' .. high_score_str, vim.log.levels.INFO)
        end
      end
    end

    run_config_pulse_once_per_day()
  end,
})
