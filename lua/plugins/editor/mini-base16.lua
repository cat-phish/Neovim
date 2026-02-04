return {
  'nvim-mini/mini.base16',
  version = false,
  event = 'VeryLazy',
  config = function()
    require('mini.base16').setup {
      --base00 - Default Background
      --base01 - Lighter Background (Used for status bars, line number and folding marks)
      --base02 - Selection Background
      --base03 - Comments, Invisibles, Line Highlighting
      --base04 - Dark Foreground (Used for status bars)
      --base05 - Default Foreground, Caret, Delimiters, Operators
      --base06 - Light Foreground (Not often used)
      --base07 - Light Background (Not often used)
      --base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      --base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
      --base0A - Classes, Markup Bold, Search Text Background
      --base0B - Strings, Inherited Class, Markup Code, Diff Inserted
      --base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
      --base0D - Functions, Methods, Attribute IDs, Headings
      --base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
      --base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
      palette = {
        base00 = '#000050',
        base01 = '#000039',
        base02 = '#292e42',
        base03 = '#6887da',
        base04 = '#dfe2f1',
        base05 = '#d1d4dc',
        base06 = '#9d7cd8',
        base07 = '#6cc254',
        base08 = '#dfe2f1',
        base09 = '#c76b29',
        base0A = '#2ac3de',
        base0B = '#6cc254',
        base0C = '#7aa2f7',
        base0D = '#dbcd00',
        base0E = '#ff9e64',
        base0F = '#a9b1d6',
      },
      use_cterm = false,
      plugins = { default = true },
    }
    vim.api.nvim_set_hl(0, 'FlashLabel', { bg = '#fc0734' })
    -- vim.g.colors_name = 'base16-gruvbox-dark-medium'
  end,
}
