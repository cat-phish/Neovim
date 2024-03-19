return {
   "tamton-aquib/duck.nvim",
   event = "VeryLazy",
   config = function()
      vim.keymap.set("n", "<leader>udh", function()
         require("duck").hatch()
      end, { desc = "Hatch duck" })
      vim.keymap.set("n", "<leader>udc", function()
         require("duck").cook()
      end, { desc = "Cook duck" })
   end,
}
