-- which-key helps you remember key bindings by showing a popup
-- with the active keybindings of the command you started typing.
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = { spelling = true },
		defaults = {
			mode = { "n", "v" },
			["g"] = { name = "+goto" },
			["gs"] = { name = "+surround" },
         ["x"] = { name = "+comment" },
			["]"] = { name = "+next" },
			["["] = { name = "+prev" },
			["<leader><tab>"] = { name = "+tabs" },
			["<leader>b"] = { name = "+buffer" },
			["<leader>c"] = { name = "+code" },
			["<leader>cp"] = { name = "+copilot" },
         ["<leader>E"] = { name = "+editor" },
			["<leader>f"] = { name = "+file/find/fuck" },
			["<leader>fm"] = { name = "+my" },
			["<leader>g"] = { name = "+git" },
			["<leader>gh"] = { name = "+hunks" },
			["<leader>h"] = { name = "+harpoon" },
			["<leader>p"] = { name = "+plugins" },
			["<leader>q"] = { name = "+quit/session" },
			["<leader>s"] = { name = "+search" },
         ["<leader>sn"] = { name = "+neovim" },
			["<leader>u"] = { name = "+ui" },
         ["<leader>ud"] = { name = "+duck" },
			["<leader>w"] = { name = "+windows" },
			["<leader>x"] = { name = "+diagnostics/quickfix" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
}
