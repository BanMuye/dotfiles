vim.pack.add({
	{
		src = "https://github.com/nvim-lualine/lualine.nvim.git",
		name = "lualine",
	},
})

require("lualine").setup({
	options = {
		theme = "auto",

		-- show one shared statusline for all windows
		globalstatus = true,

		-- enable icons
		icons_enable = true,

		-- remove separators between major sections
		section_separators = "",

		-- separate components with vertical bars
		component_separators = { left = "|", right = "|" },
	},

	sections = {
		-- current vim mode
		lualine_a = { "mode" },
		-- git branch, git changes and diagnostics
		lualine_b = { "branch", "diff", "diagnostics" },
		-- current file name
		lualine_c = { "filename" },
		-- current file type
		lualine_x = { "filetype" },
		-- positions as a percentage of the file
		lualine_y = { "progress" },
		-- cursor position
		lualine_z = { "location" },
	},
})
