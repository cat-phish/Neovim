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
      { '<leader>cPc', '<Cmd>CopilotChatOpen<CR>', mode = { 'n' }, desc = 'Copilot Chat' },
      { '<leader>cPCE', '<Cmd>CopilotChatExplain<CR>', mode = { 'n' }, desc = 'Copilot Chat Explain' },
      { '<leader>cPCR', '<Cmd>CopilotChatReset<CR>', mode = { 'n' }, desc = 'Copilot Chat Reset' },
      { '<leader>cPCS', ':CopilotChatSave ', mode = { 'n' }, desc = 'Copilot Chat Save' },
      { '<leader>cPCL', ':CopilotChatLoad ', mode = { 'n' }, desc = 'Copilot Chat Load' },
    },
    opts = {
      -- See Configuration section for options
      model = 'claude-sonnet-4',
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
