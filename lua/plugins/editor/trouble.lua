return {
  'folke/trouble.nvim',
  event = 'VeryLazy',
  cmd = { 'Trouble' },
  opts = {
    use_diagnostic_signs = true,
    modes = {
      lsp = {
        win = { position = 'right' },
      },
    },
  },
  keys = {
    { '<leader>dd', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>dD', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>ds', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
    { '<leader>dS', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP References/Definitions/... (Trouble)' },
    { '<leader>dL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>dQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    {
      '[D',
      function()
        if require('trouble').is_open() then
          require('trouble').prev { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then vim.notify(err, vim.log.levels.ERROR) end
        end
      end,
      desc = 'Prev Trouble/Quickfix Item',
    },
    {
      ']D',
      function()
        if require('trouble').is_open() then
          require('trouble').next { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then vim.notify(err, vim.log.levels.ERROR) end
        end
      end,
      desc = 'Next Trouble/Quickfix Item',
    },
  },
}
