return {
  'MagicDuck/grug-far.nvim',
  -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
  -- additional lazy config to defer loading is not really needed...
  keys = {
    {
      '<leader>srr',
      ':GrugFar<CR>',
      mode = { 'n' },
      desc = 'Replace in multiple files',
    },
    {
      '<leader>srf',
      function() require('grug-far').open { prefills = { paths = vim.fn.expand '%' } } end,
      mode = { 'n' },
      desc = 'Replace word under cursor',
    },
    {
      '<leader>srw',
      function() require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } } end,
      mode = { 'n' },
      desc = 'Replace word under cursor',
    },
    {
      '<leader>srb',
      function()
        require('grug-far').open {
          prefills = {
            paths = '<buflist>',
          },
        }
      end,
      mode = { 'n' },
      desc = 'Replace in open buffers',
    },
    -- {
    --   '<leader>srb',
    --   function()
    --     local buffers = vim.api.nvim_list_bufs()
    --     local paths = {}
    --     for _, buf in ipairs(buffers) do
    --       if vim.api.nvim_buf_get_option(buf, 'buflisted') then
    --         local path = vim.api.nvim_buf_get_name(buf)
    --         -- Only include actual files (not empty, not special buffers)
    --         if path ~= '' and vim.fn.filereadable(path) == 1 then table.insert(paths, vim.fn.fnameescape(path)) end
    --       end
    --     end
    --     require('grug-far').open { prefills = { paths = table.concat(paths, ' ') } }
    --   end,
    --   desc = 'Replace in open buffers',
    -- },
    {
      '<leader>srr',
      ':GrugFarWithin<CR>',
      mode = { 'x' },
      desc = 'Replace in visual selection',
    },
    -- {
    --   '<leader>srh',
    --   function() require('grug-far').toggle_instance { instanceName = 'history', staticTitle = 'Search History' } end,
    --   desc = 'Replace history',
    -- },
    -- TODO: not workings?
    vim.keymap.set('n', '<leader>srh', function()
      require('grug-far').toggle_instance { instanceName = 'history', staticTitle = ' Search History ' }
      -- vim.cmd('GrugFar history')
    end, { desc = 'Grug-far: Open History' }),
  },
  config = function()
    -- optional setup call to override plugin options
    -- alternatively you can set options with vim.g.grug_far = { ... }
    require('grug-far').setup {
      -- options, see Configuration section below
      -- there are no required options atm
      windowCreationCommand = 'vsplit',
      keymaps = {
        replace = { n = 'R' }, -- Replace all
        qflist = { n = 'Q' }, -- Send to quickfix list
        syncLocations = { n = 'S' }, -- Sync all locations
        syncLine = { n = 'sl' }, -- Sync current line
        syncNext = { n = 'sn' }, -- Sync line and go to next
        syncPrev = { n = 'sp' }, -- Sync line and go to prev
        syncFile = { n = 'sf' }, -- Sync all changes in current file
        close = { n = 'q' }, -- Close
        historyOpen = { n = 'H' }, -- Open history
        historyAdd = { n = 'A' }, -- Add to history
        refresh = { n = 'F' }, -- Refresh
        openLocation = { n = '<enter>' }, -- Open file at location
        gotoLocation = { n = 'go' }, -- Go to location
        pickHistoryEntry = { n = '<enter>' },
        abort = { n = '<esc>' }, -- Abort operation
        help = { n = 'g?' }, -- Show help
        toggleShowCommand = { n = 'gp' }, -- Toggle show command
        swapEngine = { n = 'ge' },
      },
    }
  end,
}
