-- copilot suggestions and completion
return {

	-- copilot
	{
		"zbirenbaum/copilot.lua",
		vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#646D97" }),
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-BS>",
				},
				layout = {
					position = "bottom", -- | top | left | right
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<M-CR>",
					accept_word = false,
					accept_line = false,
					next = "<M-n>",
					prev = "<M-p>",
					dismiss = "<M-e>",
				},
			},
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = "node", -- Node.js version must be > 16.x
			server_opts_overrides = {},
		},
	},

	-- lualine copilot status
	{
		"nvim-lualine/lualine.nvim",
		optional = true,
		event = "VeryLazy",
		opts = function(_, opts)
			local Util = require("util")
			local colors = {
				[""] = Util.ui.fg("Special"),
				["Normal"] = Util.ui.fg("Special"),
				["Warning"] = Util.ui.fg("DiagnosticError"),
				["InProgress"] = Util.ui.fg("DiagnosticWarn"),
			}
			table.insert(opts.sections.lualine_x, 2, {
				function()
					local icon = require("config").icons.kinds.Copilot
					local status = require("copilot.api").status.data
					return icon .. (status.message or "")
				end,
				cond = function()
					if not package.loaded["copilot"] then
						return
					end
					local ok, clients = pcall(require("util").lsp.get_clients, { name = "copilot", bufnr = 0 })
					if not ok then
						return false
					end
					return ok and #clients > 0
				end,
				color = function()
					if not package.loaded["copilot"] then
						return
					end
					local status = require("copilot.api").status.data
					return colors[status.status] or colors[""]
				end,
			})
		end,
	},

   -- NOTE: disabled in favor of virtual text
	-- copilot cmp source
	-- {
	-- 	"nvim-cmp",
	-- 	dependencies = {
	-- 		{
	-- 			"zbirenbaum/copilot-cmp",
	-- 			dependencies = "copilot.lua",
	-- 			opts = {},
	-- 			config = function(_, opts)
	-- 				local copilot_cmp = require("copilot_cmp")
	-- 				copilot_cmp.setup(opts)
	-- 				-- attach cmp source whenever copilot attaches
	-- 				-- fixes lazy-loading issues with the copilot cmp source
	-- 				require("util").lsp.on_attach(function(client)
	-- 					if client.name == "copilot" then
	-- 						copilot_cmp._on_insert_enter({})
	-- 					end
	-- 				end)
	-- 			end,
	-- 		},
	-- 	},
	-- 	---@param opts cmp.ConfigSchema
	-- 	opts = function(_, opts)
	-- 		table.insert(opts.sources, 1, {
	-- 			name = "copilot",
	-- 			group_index = 1,
	-- 			priority = 100,
	-- 		})
	-- 	end,
	-- },
}
