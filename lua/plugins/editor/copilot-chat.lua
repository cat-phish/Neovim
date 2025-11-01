return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    enabled = true,
    dependencies = {
      -- { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = require('nixCatsUtils').lazyAdd 'make tiktoken', -- Only on MacOS or Linux
    keys = {
      { '<leader>cpc', '<Cmd>CopilotChatOpen<CR>', mode = { 'n' }, desc = 'Copilot Chat' },
      { '<leader>cpCE', '<Cmd>CopilotChatExplain<CR>', mode = { 'n' }, desc = 'Copilot Chat Explain' },
      { '<leader>cpCR', '<Cmd>CopilotChatReset<CR>', mode = { 'n' }, desc = 'Copilot Chat Reset' },
      { '<leader>cpCS', ':CopilotChatSave ', mode = { 'n' }, desc = 'Copilot Chat Save' },
      { '<leader>cpCL', ':CopilotChatLoad ', mode = { 'n' }, desc = 'Copilot Chat Load' },
    },
    opts = {
      -- See Configuration section for options
      model = 'claude-sonnet-4',
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
