return {
  'tamton-aquib/duck.nvim',
  keys = {
    {
      '<leader>mdh',
      function()
        require('duck').hatch()
      end,
      mode = { 'n' },
      desc = 'Hatch Duck',
    },
    {
      '<leader>mdc',
      function()
        require('duck').cook()
      end,
      mode = { 'n' },
      desc = 'Cook Duck',
    },
  },
}
