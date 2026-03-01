return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = require('nixCatsUtils').lazyAdd ':TSUpdate',
  opts = {
    -- NOTE: nixCats: use lazyAdd to only set these 2 options if nix wasnt involved.
    -- because nix already ensured they were installed.
    ensure_installed = require('nixCatsUtils').lazyAdd {
      'bash',
      'c',
      'cpp',
      'diff',
      'html',
      'javascript',
      'json',
      'jsonc',
      'lua',
      'luadoc',
      'luap',
      'markdown',
      'markdown_inline',
      'org',
      'printf',
      'python',
      'query',
      'regex',
      'toml',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
      'zsh',
    },
    -- Autoinstall languages that are not installed
    auto_install = require('nixCatsUtils').lazyAdd(true, false),
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },

    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  config = function(_, opts)
    -- Prefer git instead of curl in order to improve connectivity in some environments
    require('nvim-treesitter.install').prefer_git = true

    -- Setup treesitter with opts
    require('nvim-treesitter.config').setup(opts)

    -- -- Custom filetype registrations
    -- vim.filetype.add {
    --   extension = {
    --     csproj = 'xml',
    --     esproj = 'xml',
    --     keymap = 'c',
    --     mdx = 'markdown',
    --     uproject = 'json',
    --     wsdl = 'xml',
    --   },
    -- }

    -- Optional: Setup treesitter-based folding for specific filetypes
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'lua', 'python', 'javascript', 'typescript', 'rust', 'go', 'c', 'cpp' }, -- Add your preferred languages
      callback = function()
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldenable = false -- Don't fold by default
      end,
    })
  end,
}
