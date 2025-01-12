return {
  'nvim-orgmode/telescope-orgmode.nvim',
  ft = { 'org' },
  dependencies = {
    'nvim-orgmode/orgmode',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('telescope').load_extension 'orgmode'

    vim.keymap.set('n', '<localleader>r', require('telescope').extensions.orgmode.refile_heading)
    vim.keymap.set('n', '<localleader>fh', require('telescope').extensions.orgmode.search_headings)
    vim.keymap.set('n', '<localleader>li', require('telescope').extensions.orgmode.insert_link)
  end,
}
