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
        max_width = { 40, 0.2 },
        min_width = 15,
        resize_to_content = true,
      },
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      -- disabled in favor of filetype autocmd below
      -- on_attach = function(bufnr)
      --   -- Jump forwards/backwards with '{' and '}'
      --   vim.keymap.set('n', '<C-p>', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      --   vim.keymap.set('n', '<C-n>', '<cmd>AerialNext<CR>', { buffer = bufnr })
      -- end,
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
    -- Toggle keymap (version with ! keeps cursor in current window)
    vim.keymap.set('n', '<leader>co', '<cmd>AerialToggle<CR>', { desc = 'Code Overview' })
    -- vim.keymap.set('n', '<leader>co', '<cmd>AerialToggle!<CR>', { desc = 'Code Overview' })
  end,
}
