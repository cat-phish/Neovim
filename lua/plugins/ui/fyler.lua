return {
  'A7Lavinraj/fyler.nvim',
  -- 'cat-phish/fyler.nvim', -- my fork for bug fixes
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
  branch = 'main',
  lazy = false,
  opts = {
    hooks = {},
    integrations = {
      icon = 'nvim_web_devicons',
      winpick = {
        provider = 'snacks',
        opts = {},
      },
    },
    views = {
      finder = {
        close_on_select = false,
        confirm_simple = false,
        default_explorer = false,  -- Disabled: we handle directory opening in autocmd
        delete_to_trash = false,
        -- columns_order = { "permission", "size", "git", "diagnostic" },
        columns_order = { 'git', 'diagnostic' },
        columns = {
          git = {
            enabled = true,
            symbols = {
              Untracked = '?',
              Added = '+',
              Modified = '*',
              Deleted = 'x',
              Renamed = '>',
              Copied = '~',
              Conflict = '!',
              Ignored = '#',
            },
          },
          diagnostic = {
            enabled = true,
            symbols = {
              Error = 'E',
              Warn = 'W',
              Info = 'I',
              Hint = 'H',
            },
          },
          permission = {
            enabled = true,
          },
          size = {
            enabled = true,
          },
        },
        icon = {
          directory_collapsed = nil,
          directory_empty = nil,
          directory_expanded = nil,
        },
        indentscope = {
          enabled = true,
          group = 'FylerIndentMarker',
          markers = {
            { '│', 'FylerIndentMarker' },
            { '└', 'FylerIndentMarker' },
          },
        },
        mappings = {
          ['q'] = function()
            -- Only close the current window, not all fyler instances
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_close(win, false)
          end,
          ['<CR>'] = 'Select',
          ['<2-LeftMouse>'] = 'Select',
          -- ['<C-t>'] = 'SelectTab',
          -- ['|'] = 'SelectVSplit',
          -- ['-'] = 'SelectSplit',
          ['^'] = 'GotoParent',
          ['='] = 'GotoCwd',
          ['.'] = 'GotoNode',
          ['#'] = 'CollapseAll',
          ['<BS>'] = 'CollapseNode',
        },
        mappings_opts = {
          nowait = false,
          noremap = true,
          silent = true,
        },
        follow_current_file = true,
        watcher = {
          enabled = true,
        },
        win = {
          border = vim.o.winborder == '' and 'single' or vim.o.winborder,
          buf_opts = {
            bufhidden = 'hide',
            buflisted = false,
            buftype = 'acwrite',
            expandtab = true,
            filetype = 'fyler',
            shiftwidth = 2,
            syntax = 'fyler',
            swapfile = false,
          },
          kind = 'split_left_most',
          kinds = {
            float = {
              height = '70%',
              width = '70%',
              top = '10%',
              left = '15%',
            },
            replace = {},
            split_above = {
              height = '70%',
              win_opts = {
                winfixheight = true,
              },
            },
            split_above_all = {
              height = '70%',
              win_opts = {
                winfixheight = true,
              },
            },
            split_below = {
              height = '70%',
              win_opts = {
                winfixheight = true,
              },
            },
            split_below_all = {
              height = '70%',
              win_opts = {
                winfixheight = true,
              },
            },
            split_left = {
              width = '14%',
              win_opts = {
                winfixwidth = true,
              },
            },
            split_left_most = {
              width = '14%',
              win_opts = {
                winfixwidth = true,
              },
            },
            split_right = {
              width = '30%',
              win_opts = {
                winfixwidth = true,
              },
            },
            split_right_most = {
              width = '30%',
              win_opts = {
                winfixwidth = true,
              },
            },
          },
          win_opts = {
            -- winfixbuf = true,
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
      },
    },
  },
  keys = {
    { 
      '<leader>e', 
      function() 
        local layout_config = require('config.layout')
        local fyler_width = math.floor(vim.o.columns * layout_config.fyler_width_percent)
        local aerial_width = math.floor(vim.o.columns * layout_config.aerial_width_percent)
        
        -- Check if fyler is already open
        local fyler_open = false
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == 'fyler' then
            fyler_open = true
            break
          end
        end
        
        -- Toggle fyler using split_left_most to ensure it's always on the far left
        require('fyler').toggle { kind = 'split_left_most' }
        
        -- Use defer_fn to handle timing (mimic startup)
        vim.defer_fn(function()
          -- Set aerial width
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'aerial' then
              vim.api.nvim_win_set_width(win, aerial_width)
              vim.wo[win].winfixwidth = true
            end
          end
          
          -- Also restore fyler width if it just opened
          if not fyler_open then
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype == 'fyler' then
                vim.wo[win].winfixwidth = false
                vim.api.nvim_win_set_width(win, fyler_width)
                vim.wo[win].winfixwidth = true
              end
            end
          end
          
          -- Add double-pass for fyler to ensure it sticks
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
      end, 
      desc = 'Explorer Toggle' 
    },
    { '-', function() require('fyler').open { kind = 'float' } end, desc = 'Explorer Float' },
  },
}
