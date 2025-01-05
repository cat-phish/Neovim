-- Finds and lists all of the TODO, HACK, BUG, etc comment
-- in your project and loads them into a browsable list.
return {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	opts = {},
   keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>Dt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>DT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
   },
}
