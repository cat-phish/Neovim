return {
  'nvim-orgmode/telescope-orgmode.nvim',
  ft = { 'org' },
  dependencies = {
    'nvim-orgmode/orgmode',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('telescope').load_extension 'orgmode'

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'org',
      group = vim.api.nvim_create_augroup('orgmode_telescope_nvim', { clear = true }),
      callback = function()
        vim.keymap.set('n', '<leader>or', require('telescope').extensions.orgmode.refile_heading, { desc = 'Refile Heading' })
        vim.keymap.set('n', '<leader>ofh', require('telescope').extensions.orgmode.search_headings, { desc = 'Search Headings' })
        vim.keymap.set('n', '<leader>oli', require('telescope').extensions.orgmode.insert_link, { desc = 'Insert Link' })
      end,
    })
  end,
}
