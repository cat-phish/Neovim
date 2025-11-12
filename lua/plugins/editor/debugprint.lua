return {
  'andrewferrier/debugprint.nvim',
  opts = {
    keymaps = {
      normal = {
        plain_below = '<leader>cpp',
        plain_above = '<leader>cpP',
        variable_below = '<leader>cpv',
        variable_above = '<leader>cpV',
        variable_below_alwaysprompt = '',
        variable_above_alwaysprompt = '',
        surround_plain = '<leader>cpsp',
        surround_variable = '<leader>cpsv',
        surround_variable_alwaysprompt = '',
        textobj_below = '<leader>cpo',
        textobj_above = '<leader>cpO',
        textobj_surround = '<leader>cpso',
        toggle_comment_debug_prints = '<leader>cpc',
        delete_debug_prints = '<leader>cpD',
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
    --   ['cpp'] = {
    --     left = '// clang-format off\nstd::cerr << "',
    --     right = '" << std::endl;\n// clang-format on',
    --     mid_var = ' << ',
    --     right_var = ' << std::endl;\n// clang-format on',
    --   },
    -- },
  },
}
