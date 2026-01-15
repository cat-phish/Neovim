return {
  'A7Lavinraj/fyler.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  branch = 'stable',
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
        },
        icon = {
          directory_collapsed = nil,
          directory_empty = nil,
          directory_expanded = nil,
        },
        indentscope = {
          enabled = true,
          group = 'FylerIndentMarker',
          marker = '│',
        },
        mappings = {
          ['q'] = 'CloseView',
          ['<CR>'] = 'Select',
          ['<2-LeftMouse>'] = 'Select',
          ['<C-t>'] = 'SelectTab',
          ['|'] = 'SelectVSplit',
          ['-'] = 'SelectSplit',
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
            filetype = 'fyler',
            syntax = 'fyler',
            buflisted = false,
            buftype = 'acwrite',
            expandtab = true,
            shiftwidth = 2,
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
            },
            split_above_all = {
              height = '70%',
              win_opts = {
                winfixheight = true,
              },
            },
            split_below = {
              height = '70%',
            },
            split_below_all = {
              height = '70%',
              win_opts = {
                winfixheight = true,
              },
            },
            split_left = {
              width = '15%',
            },
            split_left_most = {
              width = '15%',
              win_opts = {
                winfixwidth = true,
              },
            },
            split_right = {
              width = '30%',
            },
            split_right_most = {
              width = '30%',
              win_opts = {
                winfixwidth = true,
              },
            },
          },
          win_opts = {
            winfixbuf = true,
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
    { '<leader>e', '<Cmd>Fyler<Cr>', desc = 'Open Fyler View' },
  },
  config = function(_, opts)
    require('fyler').setup(opts)

    -- automatically open fyler when nvim is opened with a directory
    -- vim.api.nvim_create_autocmd('VimEnter', {
    --   callback = function()
    --     -- Only trigger for `nvim .`
    --     if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
    --       -- Set cwd explicitly
    --       vim.cmd('cd ' .. vim.fn.fnameescape(vim.fn.argv(0)))
    --
    --       -- Replace the directory buffer with a clean empty one
    --       vim.cmd 'enew'
    --       vim.bo.buflisted = false
    --
    --       -- Open Fyler (respects kind = split_left)
    --       vim.cmd 'Fyler'
    --     end
    --   end,
    -- })

    -- this autocmd creates a special class of window for bufferline.nvim
    -- to interact with so that it doesn't open normal buffers in fyler
    -- local last_normal_win = nil
    -- vim.api.nvim_create_autocmd('WinEnter', {
    --   callback = function()
    --     local bt = vim.bo.buftype
    --     local ft = vim.bo.filetype
    --
    --     -- Normal, editable file buffers only
    --     if bt == '' and ft ~= 'fyler' then last_normal_win = vim.api.nvim_get_current_win() end
    --   end,
    -- })
  end,
}
