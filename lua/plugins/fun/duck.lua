return {
  'tamton-aquib/duck.nvim',
  keys = {
    {
      '<leader>Mdh',
      function() require('duck').hatch() end,
      mode = { 'n' },
      desc = 'Hatch Duck',
    },
    {
      '<leader>Mdc',
      function() require('duck').cook() end,
      mode = { 'n' },
      desc = 'Cook Duck',
    },
  },
}
