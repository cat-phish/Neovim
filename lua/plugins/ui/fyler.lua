return {
  'FylerOrg/fyler.nvim', -- Updated to the new V2 organization
  branch = 'main',
  lazy = false,
  opts = {
    hooks = {},

    integrations = {
      icon = 'nvim_web_devicons',
      winpick = {
        provider = 'snacks',
        opts = {
          -- The filter function tells Snacks which windows to ignore
          filter = function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            local exclude = { 'aerial', 'fyler', 'NvimTree', 'neo-tree' }
            return not vim.tbl_contains(exclude, ft)
          end,
        },
      },
    },

    -- V2 MIGRATION: follow_current_file was moved to the root table
    follow_current_file = true,

    -- V2 MIGRATION: Set your default fallback buffer kind
    kind = 'split_left_most',

    -- V2 MIGRATION: UI elements (like hidden files and indents) live here now
    ui = {
      hidden_items = {
        -- Clear 'dotfiles' from the switches list to show hidden files by default
        switches = {},
      },
      indent_guides = true,
    },

    -- V2 MIGRATION: Extensions like Git and diagnostics
    extensions = {
      git = { enabled = true },
      -- diagnostic = { enabled = true }, -- Disabled until V2 publishes the extension
    },

    -- V2 MIGRATION: Window configurations moved from views.finder.win to kind_presets
    kind_presets = {
      split_left_most = {
        width = '14%',
        win_opts = {
          winfixwidth = true,
          concealcursor = 'nvic',
          conceallevel = 3,
          cursorline = false,
          number = true,
          relativenumber = true,
          winhighlight = 'Normal:FylerNormal,NormalNC:FylerNormalNC',
          wrap = false,
          signcolumn = 'no',
        },
      },
      floating = {
        height = '70%',
        width = '70%',
      },
    },

    -- V2 MIGRATION: Mappings must be nested by mode ('n' for normal) and use the 'action' key
    mappings = {
      n = {
        ['q'] = {
          action = function()
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_close(win, false)
          end,
        },
        ['<CR>'] = { action = 'select' },
        ['<2-LeftMouse>'] = { action = 'select' },
        ['^'] = { action = 'goto_parent' },
        ['='] = { action = 'goto_cwd' },
        ['.'] = { action = 'goto_node' },
        ['#'] = { action = 'collapse_all' },
        ['<BS>'] = { action = 'collapse_node' },
      },
    },
  },
  keys = {
    {
      '<leader>e',
      function()
        local layout_config = require 'config.layout'
        local fyler_width = math.floor(vim.o.columns * layout_config.fyler_width_percent)
        local aerial_width = math.floor(vim.o.columns * layout_config.aerial_width_percent)

        -- PREVENT LAYOUT SHIFT: Disable auto-balancing
        local ead_state = vim.o.equalalways
        vim.o.equalalways = false

        -- Toggle fyler using split_left_most to ensure it's always on the far left
        require('fyler').toggle { kind = 'split_left_most' }

        -- Cleanly enforce widths in a single pass
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype

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

          -- Balance the center buffers, ignoring Fyler and Aerial
          vim.cmd 'wincmd ='

          -- Force Bufferline to recalculate its offsets with the correct widths
          vim.cmd 'redrawtabline'
        end)
      end,
      desc = 'Explorer Toggle',
    },
    {
      '-',
      -- V2 MIGRATION: The float preset was renamed to 'floating'
      function() require('fyler').open { kind = 'floating' } end,
      desc = 'Explorer Float',
    },
  },
}
