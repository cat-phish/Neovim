return {
  'andrewferrier/debugprint.nvim',
  opts = {
    keymaps = {
      normal = {
        plain_below = '<leader>ipp',
        plain_above = '<leader>ipP',
        variable_below = '<leader>ipv',
        variable_above = '<leader>ipV',
        variable_below_alwaysprompt = '',
        variable_above_alwaysprompt = '',
        surround_plain = '<leader>ipsp',
        surround_variable = '<leader>ipsv',
        surround_variable_alwaysprompt = '',
        textobj_below = '<leader>ipo',
        textobj_above = '<leader>ipO',
        textobj_surround = '<leader>ipso',
        toggle_comment_debug_prints = '<leader>ipc',
        delete_debug_prints = '<leader>ipD',
      },
      insert = {
        -- plain = '<C-G>p',
        -- variable = '<C-G>v',
      },
      visual = {
        -- variable_below = 'g?v',
        -- variable_above = 'g?V',
      },
    },
    highlight_lines = false,
    -- filetypes = {
    --   ['c'] = {
    --     left = '// clang-format off\nstd::cerr << "',
    --     right = '" << std::endl;\n// clang-format on',
    --     mid_var = ' << ',
    --     right_var = ' << std::endl;\n// clang-format on',
    --   },
    --   ['ipp'] = {
    --     left = '// clang-format off\nstd::cerr << "',
    --     right = '" << std::endl;\n// clang-format on',
    --     mid_var = ' << ',
    --     right_var = ' << std::endl;\n// clang-format on',
    --   },
    -- },
  },
}
