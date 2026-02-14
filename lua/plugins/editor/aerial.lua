return {
  'stevearc/aerial.nvim',
  opts = {},
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup {
      keymaps = {},
      backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },
      layout = {
        max_width = { 200, 0.4 },  -- Allow up to 200 columns or 40% of screen
        min_width = 25,
        resize_to_content = false,
        default_direction = 'right',
        placement = 'edge',
      },
    }

    -- Only map C-n / C-p when we are physically in the Aerial buffer
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'aerial',
      callback = function()
        -- These are buffer-local to the Aerial window only
        vim.keymap.set('n', '<C-n>', '<cmd>AerialNext<CR>', { buffer = true, silent = true })
        vim.keymap.set('n', '<C-p>', '<cmd>AerialPrev<CR>', { buffer = true, silent = true })
      end,
    })
    -- Toggle keymap with explicit width setting
    vim.keymap.set('n', '<leader>co', function()
      local layout_config = require('config.layout')
      local aerial_width = math.floor(vim.o.columns * layout_config.aerial_width_percent)
      local fyler_width = math.floor(vim.o.columns * layout_config.fyler_width_percent)
      
      -- Check if aerial is already open
      local aerial_open = false
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'aerial' then
          aerial_open = true
          break
        end
      end
      
      if aerial_open then
        -- Close aerial
        vim.cmd('AerialClose')
        -- Restore fyler width after aerial closes
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'fyler' then
              vim.wo[win].winfixwidth = false
              vim.api.nvim_win_set_width(win, fyler_width)
              vim.wo[win].winfixwidth = true
            end
          end
        end)
      else
        -- Open aerial and set width
        vim.cmd('AerialOpen right')
        -- Use defer_fn instead of schedule to give Aerial time to initialize (mimics startup timing)
        vim.defer_fn(function()
          -- Set aerial width (don't disable winfixwidth first - match startup pattern)
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'aerial' then
              vim.api.nvim_win_set_width(win, aerial_width)
              vim.wo[win].winfixwidth = true
            end
          end
          -- Also restore fyler width
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'fyler' then
              vim.wo[win].winfixwidth = false
              vim.api.nvim_win_set_width(win, fyler_width)
              vim.wo[win].winfixwidth = true
            end
          end
          
          -- Add extra schedule to ensure fyler width sticks
          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == 'fyler' then
                vim.wo[win].winfixwidth = false
                vim.api.nvim_win_set_width(win, fyler_width)
                vim.wo[win].winfixwidth = true
              end
            end
          end)
        end, 20)
      end
    end, { desc = 'Code Overview' })
  end,
}
