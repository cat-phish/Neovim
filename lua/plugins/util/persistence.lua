-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.
return {
   'folke/persistence.nvim',
   event = 'BufReadPre',
   opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
}
