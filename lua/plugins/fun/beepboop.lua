return {
  'EggbertFluffle/beepboop.nvim',
  keys = {
    {
      '<leader>mowaaa',
      function()
        local Util = require 'config.utils'
        Util.warn('Get down with the sickness', { title = 'Ooh-Wah-Ah-Ah-Ah!' })
      end,
      mode = { 'n' },
      desc = 'ah',
    },
  },
  opts = {
    audio_player = 'paplay',
    max_sounds = 20,
    sound_directory = '~/.config/sounds/',
    sound_map = {
      { key_map = { mode = 'n', key_chord = '<leader>mowaaa' }, sound = 'ooh-wah-ah-ah-ah.opus' },
    },
  },
}
