-- TODO: come back to this when treesitter fix is implemented
-- https://github.com/code-biscuits/nvim-biscuits/issues/60
return {
  'code-biscuits/nvim-biscuits',
  -- event = 'VeryLazy',
  event = { 'BufReadPost', 'BufNewFile' }, -- Load after files are read
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter',
  -- },
  config = function()
    require('nvim-biscuits').setup {
      -- toggle_keybind = "<leader>Eb",
      default_config = {
        cursor_line_only = true,
        max_length = 10,
        trim_by_words = true,
        min_distance = 5,
        -- prefix_string = "🍪",
        prefix_string = '  🐒',
      },
      language_config = {
        help = {
          disabled = true,
        },
        vimdoc = {
          disabled = true,
        },
      },
    }
  end,
}
