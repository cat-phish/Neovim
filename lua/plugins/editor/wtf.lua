-- debug diagnostics with AI and Google
return {
  'piersolenski/wtf.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  opts = {
    chat_dir = vim.fn.stdpath('data'):gsub('/$', '') .. '/wtf_chats',
    -- Default AI popup type
    popup_type = 'popup',
    -- An alternative way to set your API key
    -- openai_api_key = '',
    -- ChatGPT Model
    providers = {
      openai = {
        model_id = 'gpt-3.5-turbo',
      },
    },
    -- Send code as well as diagnostics NOTE: deprecated?
    -- context = true,

    -- Set your preferred language for the response
    language = 'english',
    -- Any additional instructions
    additional_instructions = nil,
    -- Default search engine, can be overridden by passing an option to WtfSearch
    search_engine = 'google',
    -- Picker
    picker = 'snacks',
    -- Callbacks
    hooks = {
      request_started = nil,
      request_finished = nil,
    },
    -- Add custom colours
    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  },
  keys = {
    {
      '<leader>cD',
      mode = { 'n', 'x' },
      function() require('wtf').diagnose() end,
      desc = 'Debug Diagnostic with AI',
    },
    {
      mode = { 'n' },
      '<leader>cG',
      function() require('wtf').search() end,
      desc = 'Search Diagnostic with Google',
    },
  },
}
