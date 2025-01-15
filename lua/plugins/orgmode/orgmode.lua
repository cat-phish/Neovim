return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  dependencies = {
    'nvim-orgmode/orgmode',
    'chipsenkbeil/org-roam.nvim',
    'nvim-orgmode/telescope-orgmode.nvim',
    'akinsho/org-bullets.nvim',
    'lukas-reineke/headlines.nvim',
    'dhruvasagar/vim-table-mode',
  },
  config = {
    function()
      require('orgmode').setup {
        -- Setup orgmode
        org_agenda_files = '~/orgfiles/**/*',
        org_default_notes_file = '~/orgfiles/refile.org',

        -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
        -- add ~org~ to ignore_install
        -- require('nvim-treesitter.configs').setup({
        --   ensure_installed = 'all',
        --   ignore_install = { 'org' },
        -- })
        mappings = {
          org_return_uses_meta_return = false,
          global = {
            -- prefix = { '<localleader>', desc = 'org-mode' },
            -- org_toggle_checkbox = '<localleader><CR>',
          },
        },
      }
    end,
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'org',
      callback = function()
        vim.keymap.set({ 'i' }, '<C-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
          silent = true,
          buffer = true,
        })
        vim.keymap.set({ 'n' }, '<CR>', '<cmd>lua require("orgmode").action("org_mappings.toggle_checkbox")<CR>', {
          silent = true,
          buffer = true,
        })
      end,
    }),
  },
}
