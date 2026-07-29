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
      -- This line tells Aerial to stay open even on empty/unsupported buffers
      -- close_automatic_events = {},

      keymaps = {},
      backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },
      layout = {
        max_width = { 200, 0.4 }, -- Allow up to 200 columns or 40% of screen
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
      local layout_config = require 'config.layout'
      local aerial_width = math.floor(vim.o.columns * layout_config.aerial_width_percent)
      local fyler_width = math.floor(vim.o.columns * layout_config.fyler_width_percent)

      -- PREVENT LAYOUT SHIFT: Disable auto-balancing
      local ead_state = vim.o.equalalways
      vim.o.equalalways = false

      -- FIX: The bang (!) forces Aerial to open even on empty/unsupported buffers
      vim.cmd 'AerialToggle! right'

      -- Cleanly enforce widths in a single pass
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype

          if ft == 'fyler' then
            vim.wo[win].winfixwidth = false
            vim.api.nvim_win_set_width(win, fyler_width)
            vim.wo[win].winfixwidth = true
          elseif ft == 'aerial' then
            vim.wo[win].winfixwidth = false
            vim.api.nvim_win_set_width(win, aerial_width)
            vim.wo[win].winfixwidth = true
          end
        end

        -- IMPORTANT: Restore auto-balancing ONLY AFTER widths are locked
        vim.o.equalalways = ead_state

        -- Tell Neovim to stretch the central code buffer to fill the remaining space.
        vim.cmd 'wincmd ='

        -- Force Bufferline to recalculate its offsets with the correct widths
        vim.cmd 'redrawtabline'
      end)
    end, { desc = 'Code Overview' })
  end,
}
