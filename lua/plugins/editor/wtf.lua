-- debug diagnostics with AI and Google
return {
  'piersolenski/wtf.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  opts = {
    -- Default AI popup type
    popup_type = 'popup',
    -- An alternative way to set your API key
    -- openai_api_key = '',
    -- ChatGPT Model
    openai_model_id = 'gpt-3.5-turbo',
    -- Send code as well as diagnostics
    context = true,
    -- Set your preferred language for the response
    language = 'english',
    -- Any additional instructions
    additional_instructions = nil,
    -- Default search engine, can be overridden by passing an option to WtfSearch
    search_engine = 'google',
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
      function()
        require('wtf').ai()
      end,
      desc = 'Debug diagnostic with AI',
    },
    {
      mode = { 'n' },
      '<leader>cG',
      function()
        require('wtf').search()
      end,
      desc = 'Search diagnostic with Google',
    },
  },
  -- config = function()
  --   -- HACK: Extremely hacky way to make sure wtf closes with q
  --   -- Set a custom buffer variable when the wtf.nvim window is created
  --   -- and change the filetype to work with the close with q autocmd.
  --   -- Will close all floating windows with the filetype 'markdown'
  --   -- with q
  --   vim.api.nvim_create_autocmd('BufWinEnter', {
  --     pattern = '*',
  --     callback = function()
  --       local filetype = vim.bo.filetype
  --
  --       if filetype == 'markdown' then
  --         -- Check if the buffer is a floating window
  --         local winid = vim.fn.win_getid()
  --         local config = vim.api.nvim_win_get_config(winid)
  --         if config.relative ~= '' then
  --           vim.bo.filetype = 'markdown_floating_win'
  --         end
  --       end
  --     end,
  --   })
  -- end,
}
