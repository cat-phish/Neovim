return {
  'MeF0504/vim-pets',
  event = 'VeryLazy',
  config = function()
    vim.g.pets_default_pet = 'dog'
    vim.g.pets_lifetime_enable = 1
    vim.g.pets_birth_enable = 0
    vim.g.pets_garden_width = math.floor(vim.o.columns / 5)
    vim.g.pets_garden_height = math.floor(vim.o.lines / 4)
    vim.g.pets_garden_pos = { vim.o.lines - vim.o.cmdheight - 1, vim.o.columns - 1, 'botright' }
  end,
  keys = {
    {
      '<leader>mpc',
      function()
        vim.cmd 'Pets'
        -- vim.cmd 'PetsLeave dog'
        -- vim.cmd 'PetsJoin dog [Mac]'
        vim.cmd 'PetsJoin cat [Haxan]'
      end,
      mode = { 'n' },
      desc = 'Create Garden with Pets',
    },
    {
      '<leader>mpj',
      function()
        vim.cmd 'PetsJoin'
      end,
      mode = { 'n' },
      desc = 'Join Pet to Garden',
    },
    {
      '<leader>mpl',
      function()
        vim.cmd 'PetsLeave'
      end,
      mode = { 'n' },
      desc = 'Leave Pet from Garden',
    },
    {
      '<leader>mpt',
      function()
        vim.cmd 'PetsThrowBall'
      end,
      mode = { 'n' },
      desc = 'Throw Ball',
    },
    {
      '<leader>mpC',
      function()
        vim.cmd 'PetsClose'
      end,
      mode = { 'n' },
      desc = 'Quit Garden',
    },
    {
      '<leader>mpw',
      function()
        vim.cmd 'PetsWithYou'
      end,
      mode = { 'n' },
      desc = 'Put Pet Around Cursor',
    },
    {
      '<leader>mpW',
      function()
        vim.cmd 'PetsWithYouClear'
      end,
      mode = { 'n' },
      desc = 'Clear Pets Around Cursor',
    },
  },
}
