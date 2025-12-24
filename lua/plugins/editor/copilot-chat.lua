return {
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
  config = function(_, opts)
    require('CopilotChat').setup(opts)
    -- Auto-command to customize chat buffer behavior
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'copilot-*',
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.opt_local.conceallevel = 0
        -- Fix buffer to this window
        vim.opt_local.winfixbuf = true

        -- Optional but recommended
        vim.opt_local.winfixwidth = true
      end,
    })
  end,
}
