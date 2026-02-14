return {
  -- { 'akinsho/toggleterm.nvim', version = '*', config = true },
  -- {
  --   'akinsho/toggleterm.nvim',
  --   version = '*',
  --   opts = {
  --     direction = 'float',
  --     close_on_exit = false,
  --   },
  -- },
  'akinsho/toggleterm.nvim',
  version = '*',
  opts = {
    -- size can be a number or function which is passed the current terminal
    -- size = 10,
    -- size = 20 |
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.3
      end
    end,
    open_mapping = [[<c-\>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
    -- on_create = fun(t: Terminal), -- function to run when the terminal is first created
    -- on_open = fun(t: Terminal), -- function to run when the terminal opens
    -- on_open = function(term)
    --   -- Prevent other buffers from opening in this window
    --   vim.wo[term.window].winfixbuf = true
    -- end,
    on_open = function(term)
      -- Prevent other buffers from opening in this window
      -- vim.wo[term.window].winfixbuf = true
      vim.wo[term.window].winfixwidth = true

      -- Store the terminal window number
      vim.g.toggleterm_window = term.window
    end,
    on_close = function()
      vim.g.toggleterm_window = nil
      
      -- Restore fyler and aerial widths after a brief delay
      vim.schedule(function()
        local layout_config = require('config.layout')
        local fyler_width = math.floor(vim.o.columns * layout_config.fyler_width_percent)
        local aerial_width = math.floor(vim.o.columns * layout_config.aerial_width_percent)
        
        -- Set aerial first, then fyler
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
          if ft == 'aerial' then
            vim.wo[win].winfixwidth = false
            vim.api.nvim_win_set_width(win, aerial_width)
            vim.wo[win].winfixwidth = true
          end
        end
        
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
          if ft == 'fyler' then
            vim.wo[win].winfixwidth = false
            vim.api.nvim_win_set_width(win, fyler_width)
            vim.wo[win].winfixwidth = true
          end
        end
      end)
    end,
    -- on_close = fun(t: Terminal), -- function to run when the terminal closes
    -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
    -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
    -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
    -- highlights = {
    --   -- highlights which map to a highlight group name and a table of it's values
    --   -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    --   Normal = {
    --     guibg = "<VALUE-HERE>",
    --   },
    --   NormalFloat = {
    --     link = 'Normal'
    --   },
    --   FloatBorder = {
    --     guifg = "<VALUE-HERE>",
    --     guibg = "<VALUE-HERE>",
    --   },
    -- },
    shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
    -- shading_factor = '<number>', -- the percentage by which to lighten dark terminal background, default: -30
    -- shading_ratio = '<number>', -- the ratio of shading factor for light/dark terminal background, default: -3
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = false,  -- Don't remember terminal size between toggles
    persist_mode = false, -- if set to true (default) the previous terminal mode will be remembered
    direction = 'vertical', -- 'vertical' | 'horizontal' | 'tab' | 'float',
    close_on_exit = false, -- close the terminal window when the process exits
    clear_env = false, -- use only environmental variables from `env`, passed to jobstart()
    -- Change the default shell. Can be a string or a function returning a string
    -- shell = '/home/jordan/.nix-profile/bin/zsh'
    -- shell = vim.o.shell,
    auto_scroll = true, -- automatically scroll to the bottom on terminal output
    -- This field is only relevant if direction is set to 'float'
    -- float_opts = {
    --   -- The border key is *almost* the same as 'nvim_open_win'
    --   -- see :h nvim_open_win for details on borders however
    --   -- the 'curved' border is a custom border type
    --   -- not natively supported but implemented in this plugin.
    --   border = 'single', -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    --   -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
    --   width = 140,
    --   height = 50,
    --   -- row = <value>,
    --   -- col = <value>,
    --   -- winblend = 3,
    --   -- zindex = <value>,
    --   title_pos = 'center', -- 'left' | 'center' | 'right', position of the title of the floating window
    -- },
    -- winbar = {
    --   enabled = false,
    --   name_formatter = function(term) --  term: Terminal
    --     return term.name
    --   end,
    -- },
    responsiveness = {
      -- breakpoint in terms of `vim.o.columns` at which terminals will start to stack on top of each other
      -- instead of next to each other
      -- default = 0 which means the feature is turned off
      horizontal_breakpoint = 135,
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)
    
    -- Mark toggleterm buffers as not modified to allow :w and :wqa
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = 'term://*toggleterm#*',
      callback = function()
        vim.bo.buflisted = false
        vim.bo.modified = false
      end,
    })
    
    -- Also mark as unmodified when entering terminal buffer
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'term://*toggleterm#*',
      callback = function()
        vim.bo.modified = false
      end,
    })
    
    -- Helper function to check if any toggleterm jobs are running
    local function has_running_terminal()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname:match('term://.*toggleterm#') then
            return true
          end
        end
      end
      return false
    end
    
    -- Create wrapper commands that auto-add ! for terminal jobs
    vim.api.nvim_create_user_command('SmartQ', function()
      if has_running_terminal() then
        vim.cmd('q!')
      else
        vim.cmd('q')
      end
    end, {})
    
    vim.api.nvim_create_user_command('SmartWq', function()
      if has_running_terminal() then
        vim.cmd('wq!')
      else
        vim.cmd('wq')
      end
    end, {})
    
    vim.api.nvim_create_user_command('SmartWqa', function()
      if has_running_terminal() then
        vim.cmd('wqa!')
      else
        vim.cmd('wqa')
      end
    end, {})
    
    vim.api.nvim_create_user_command('SmartQa', function()
      if has_running_terminal() then
        vim.cmd('qa!')
      else
        vim.cmd('qa')
      end
    end, {})
    
    -- Use command abbreviations to redirect standard commands
    vim.cmd([[
      cnoreabbrev <expr> q ((getcmdtype() ==# ':' && getcmdline() ==# 'q') ? 'SmartQ' : 'q')
      cnoreabbrev <expr> wq ((getcmdtype() ==# ':' && getcmdline() ==# 'wq') ? 'SmartWq' : 'wq')
      cnoreabbrev <expr> wqa ((getcmdtype() ==# ':' && getcmdline() ==# 'wqa') ? 'SmartWqa' : 'wqa')
      cnoreabbrev <expr> qa ((getcmdtype() ==# ':' && getcmdline() ==# 'qa') ? 'SmartQa' : 'qa')
    ]])
  end,
}
