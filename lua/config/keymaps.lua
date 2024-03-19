local Util = require("util")

-- TODO: remove this
-- DO NOT USE THIS IN YOU OWN CONFIG!!
-- use `vim.keymap.set` instead
-- local map = Util.safe_keymap_set

local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		if opts.remap and not vim.g.vscode then
			opts.remap = nil
		end
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
-- map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

--keywordprg
map("n", "<leader>sK", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>pl", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>N", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- formatting
map({ "n", "v" }, "<leader>cf", function()
	Util.format({ force = true })
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start

-- toggle options
map("n", "<leader>Ef", function() Util.format.toggle() end, { desc = "Toggle auto format (global)" })
map("n", "<leader>EF", function() Util.format.toggle(true) end, { desc = "Toggle auto format (buffer)" })
map("n", "<leader>Es", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>Ew", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>En", function() Util.toggle("relativenumber") end, { desc = "Toggle Relative Line Numbers" })
map("n", "<leader>EN", function() Util.toggle.number() end, { desc = "Toggle Line Numbers" })
map("n", "<leader>Ed", function() Util.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>Ec", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  map( "n", "<leader>Eh", function() Util.toggle.inlay_hints() end, { desc = "Toggle Inlay Hints" })
end
map("n", "<leader>ET", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })
map("n", "<leader>ub", function() Util.toggle("background", false, {"light", "dark"}) end, { desc = "Toggle Background" })

-- lazygit
map("n", "<leader>gg", function() Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false }) end, { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() Util.terminal({ "lazygit" }, {esc_esc = false, ctrl_hjkl = false}) end, { desc = "Lazygit (cwd)" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- LazyVim Changelog
map("n", "<leader>pL", function() Util.news.changelog() end, { desc = "LazyVim Changelog" })

-- floating terminal
local lazyterm = function() Util.terminal(nil, { cwd = Util.root() }) end
map("n", "<leader>t", function() Util.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<leader>ut", function() Util.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<leader>uT", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
-- map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
-- map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })


-- MY KEYMAPS

-- Find buffer
-- map("n", "<leader><leader>", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<CR>", { desc = "Find Buffer" })

-- Next and Previous Buffer
-- map("n", "'", "<cmd>bnext<CR>", { desc = "Next Buffer" })
-- map("n", ";", "<cmd>bprev<CR>", { desc = "Previous Buffer" })
map("n", "<C-'>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<C-;>", "<cmd>bprev<CR>", { desc = "Previous Buffer" })

-- Begginning and End of Line
map("n", "H", "^", { desc = "Beginning of Line" })
map("n", "L", "$", { desc = "End of Line" })
map("v", "H", "^", { desc = "Beginning of Line" })
map("v", "L", "$", { desc = "End of Line" })

-- Easier redo
-- map("n", "U", "<C-r>", { desc = "Redo" })

-- Toggle Relative Line Numbers
map("n", "<leader>n", function()
   Util.toggle("relativenumber")
end, { desc = "Toggle Relative Line Numbers" })

-- Windows.nvim Window Maximizer
map("n", "<leader>wm", "<cmd>WindowsMaximize<CR>", { desc = "Maximize Window" })
map("n", "<leader>wh", "<cmd>WindowsMaximizeHorizontally<CR>", { desc = "Maximize Window (H)" })
map("n", "<leader>wv", "<cmd>WindowsMaximizeVertically<CR>", { desc = "Maximize Window (V)" })
map("n", "<leader>w=", "<cmd>WindowsEqualize<CR>", { desc = "Equalize Windows" })

-- No-Neck-Pain Plugin
map("n", "<leader>wf", "<cmd>NoNeckPain<CR>", { desc = "Focus Window" })

-- Zen Mode
map("n", "<leader>wz", "<cmd>ZenMode<CR>", { desc = "Zen Mode" })

-- Markdown Preview
map("n", "<leader>em", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown Preview" })

-- Cellular Automaton
map("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Life" })

-- Copilot
map("n", "<leader>cpE", "<cmd>Copilot enable<CR>", { desc = "Copilot Suggestions Enable" })
map("n", "<leader>cpD", "<cmd>Copilot disable<CR>", { desc = "Copilot Suggestions Disable" })

-- Biscuits Toggle
map("n", "<leader>Eb", "<cmd>lua require('nvim-biscuits').toggle_biscuits()<CR>", { desc = "Toggle Biscuits" })

-- Second Monitor Settings Toggle
map("n", "<leader>u2", function()
   vim.opt.wrap = true
   vim.opt.linebreak = true
   vim.opt.scrolloff = 999
   vim.opt.signcolumn = "no"
   vim.opt.relativenumber = false
   vim.opt.number = false
end, { desc = "Second Monitor Setting" })

-- Insert TODO comment
map("n", "<leader>T", "xx<right>a<space>TODO:<space>", { desc = "Insert TODO comment" })

-- Disable accidental of middle click pasting
-- will paste on 4 consecutive middle clicks
map("n", "<MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("i", "<MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("v", "<MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("c", "<MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("n", "<2-MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("i", "<2-MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("v", "<2-MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("c", "<2-MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("n", "<3-MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("i", "<3-MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("v", "<3-MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
map("c", "<3-MiddleMouse>", "<Nop>", { desc = "Disable Middle Click Paste" })
