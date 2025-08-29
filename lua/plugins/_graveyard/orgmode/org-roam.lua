return {
  'chipsenkbeil/org-roam.nvim',
  tag = '0.1.1',
  ft = { 'org' },
  dependencies = {
    {
      'nvim-orgmode/orgmode',
      tag = '0.3.7',
    },
  },
  config = function()
    require('org-roam').setup {
      directory = '~/.roam',
      -- optional
      -- org_files = {
      --   '~/another_org_dir',
      --   '~/some/folder/*.org',
      --   '~/a/single/org_file.org',
      -- },
      bindings = {
        prefix = ',r',
        --   add_alias = '<localleader>naa',
        --   add_original = '<localleader>nao',
        --   capture = '<localleader>nc',
        --   complete_at_point = '<localleader>n.',
        --   find_node = '<localleader>nf',
        --   goto_next_node = '<localleader>nn',
        --   goto_prev_node = '<localleader>np',
        --   insert_node = '<localleader>ni',
        --   insert_node_immediate = '<localleader>nm',
        --   quickfix_backlinks = '<localleader>nq',
        --   remove_alias = '<localleader>nar',
        --   remove_original = '<localleader>nor',
        --   toggle_roam_buffer = '<localleader>nl',
        --   toggle_roam_buffer_fixed = '<localleader>nL',
        --   capture_date = '<localleader>ndD',
        --   capture_today = '<localleader>ndN',
        --   capture_tomorrow = '<localleader>ndT',
        --   capture_yesterday = '<localleader>ndY',
        --   find_directory = '<localleader>nd.',
        --   goto_date = '<localleader>ndd',
        --   goto_next_date = '<localleader>ndf',
        --   goto_prev_date = '<localleader>ndb',
        --   goto_today = '<localleader>ndt',
        --   goto_tomorrow = '<localleader>ndt',
        --   goto_yesterday = '<localleader>ndy',
      },
    }
  end,
}
