return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    animate = { enabled = false },
    bigfile = {
      enabled = true,
      notify = true, -- show notification when big file detected
      size = 1.5 * 1024 * 1024, -- 1.5MB
      line_length = 1000, -- average line length (useful for minified files)
      -- Enable or disable features when big file detected
      ---@param ctx {buf: number, ft:string}
      setup = function(ctx)
        if vim.fn.exists ':NoMatchParen' ~= 0 then vim.cmd [[NoMatchParen]] end
        Snacks.util.wo(0, { foldmethod = 'manual', statuscolumn = '', conceallevel = 0 })
        vim.b.minianimate_disable = true
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then vim.bo[ctx.buf].syntax = ctx.ft end
        end)
      end,
    },
    bufdelete = { enabled = true },
    dashboard = { enabled = false },
    debug = { enabled = true },
    dim = { enabled = true },
    explorer = {
      enabled = false,
      layout = { preset = 'sidebar', preview = false },
      replace_netrw = true,
      hidden = true,
    },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = true }, -- TODO: get rid of mini indentscope?
    image = {
      enabled = true,
      formats = {
        'png',
        'jpg',
        'jpeg',
        'gif',
        'bmp',
        'webp',
        'tiff',
        'heic',
        'avif',
        'mp4',
        'mov',
        'avi',
        'mkv',
        'webm',
        'pdf',
      },
      force = false, -- try displaying the image, even if the terminal does not support it
      doc = {
        -- enable image viewer for documents
        -- a treesitter parser must be available for the enabled languages.
        -- supported language injections: markdown, html
        enabled = true,
        -- render the image inline in the buffer
        -- if your env doesn't support unicode placeholders, this will be disabled
        -- takes precedence over `opts.float` on supported terminals
        inline = true,
        -- render the image in a floating window
        -- only used if `opts.inline` is disabled
        float = true,
        max_width = 80,
        max_height = 40,
      },
      img_dirs = { 'img', 'images', 'assets', 'static', 'public', 'media', 'attachments' },
      -- window options applied to windows displaying image buffers
      -- an image buffer is a buffer with `filetype=image`
      wo = {
        wrap = false,
        number = false,
        relativenumber = false,
        cursorcolumn = false,
        signcolumn = 'no',
        foldcolumn = '0',
        list = false,
        spell = false,
        statuscolumn = '',
      },
      cache = vim.fn.stdpath 'cache' .. '/snacks/image',
      debug = {
        request = false,
        convert = false,
        placement = false,
      },
      env = {},
    },
    input = { enabled = true },
    layout = { enabled = false },
    lazygit = { enabled = true },
    notifier = { enabled = true }, -- TODO: get rid of nvim-notify?
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true },
      },
    },
    profiler = { enabled = true },
    quickfile = { enabled = true },
    rename = { enabled = true },
    scope = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true }, -- TODO: is this conflicting with another plugin?
    terminal = { enabled = false },
    toggle = { enabled = true },
    util = { enabled = true },
    words = { enabled = false }, -- TODO: disabled bc of inconsistent jump behavior, mappings also disabled below, using vim-illuminate
    zen = { enabled = true },
  },
  -- stylua: ignore
  keys = {
    -- { '<leader>e', function() Snacks.explorer() end, desc = 'File Explorer' }, -- disabled in favor of fyler

    -- Buffer Manipulation
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>bD', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },
    -- Pickers
    -- Top Pickers & Explorer
    { '<leader>,', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    { '<leader><space>', function() Snacks.picker.buffers() end, desc = 'Find Buffers' },
    { '<leader>/', function() Snacks.picker.lines { layout = { preview = 'main', preset = 'vertical', }, } end, desc = 'Grep in Buffer' },
    { '<leader>.', function() Snacks.scratch() end, desc = 'Scratch Buffer' },
    -- find
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffer' },
    { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Config File' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'File' },
    { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Git File' },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Project' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent' },
    { '<leader>fs', function() Snacks.scratch.select() end, desc = 'Scratch Buffer' },
    -- git
    { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' } },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
    { '<leader>gL', function() Snacks.picker.git_log_line() end, desc = 'Git Log Lines' },
    { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status' },
    { '<leader>gS', function() Snacks.picker.git_stash() end, desc = 'Git Stash' },
    { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git Diff (Hunks)' },
    { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git Log File' },
    -- Search
    { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer' },
    { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Open Buffers' },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Word or Visual Selection', mode = { 'n', 'x' } },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search History' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
    { '<leader>sh', function() Snacks.picker.highlights() end, desc = 'Highlights' },
    { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons' },
    { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
    { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List' },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
    { '<leader>sr', function() Snacks.picker.resume() end, desc = 'Resume' },
    { '<leader>s:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    -- Search Neovim
    { '<leader>sna', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
    { '<leader>snc', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '<leader>snC', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>snk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>snh', function() Snacks.picker.help() end, desc = 'Help Pages' },
    { '<leader>snN', function() Snacks.notifier.show_history() end, desc = 'Notification History' },
    { '<leader>snn', function() Snacks.picker.notifications() end, desc = 'Notification History' },
    { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History' },
    { '<leader>snM', function() Snacks.picker.man() end, desc = 'Man Pages' },
    { '<leader>snp', function() Snacks.picker.lazy() end, desc = 'Search for Plugin Spec' },
    { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
    -- LSP
    { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto Declaration' },
    { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
    { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation' },
    { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition' },
    -- Code
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename File' },
    { '<leader>cs', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols' },
    { '<leader>cS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols' },
    -- Other
    -- { '<leader>uz', function() Snacks.zen() end, desc = 'Super Zen Mode' },
    { '<leader>uZ', function() Snacks.zen.zoom() end, desc = 'Toggle Zoom' },

    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },

    -- TODO: These mappings are disabled because they conflict with vim-illuminate and produced inconsistent behavior
    -- { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    -- { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },

    {
      '<leader>snu',
      desc = 'Neovim Updates',
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = 'yes',
            statuscolumn = ' ',
            conceallevel = 3,
          },
        }
      end,
    },
  },
}
