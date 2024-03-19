-- Automatically add closing tags for HTML and JSX
return {
	"windwp/nvim-ts-autotag",
	-- TODO: check to change back to event LazyFile
	-- event = "LazyFile",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	opts = {},
}
