return {
  -- 'norcalli/nvim-colorizer.lua',
  'catgoose/nvim-colorizer.lua', -- switched to this fork, seems more active, also already pkgd in nix
  event = 'VeryLazy',
  config = function()
    require('colorizer').setup()
  end,
}
