return {
  'A7Lavinraj/fyler.nvim',
  -- 'cat-phish/fyler.nvim', -- my fork for bug fixes
  dependencies = { 'nvim-tree/nvim-web-devicons' },
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
        default_explorer = true,
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
          ['q'] = 'CloseView',
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
          enabled = false,
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
              width = '17%',
              win_opts = {
                winfixwidth = true,
              },
            },
            split_left_most = {
              width = '17%',
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
    { '<leader>e', function() require('fyler').toggle { kind = 'split_left' } end, desc = 'Explorer Toggle' },
    { '-', function() require('fyler').open { kind = 'float' } end, desc = 'Explorer Float' },
  },
}
