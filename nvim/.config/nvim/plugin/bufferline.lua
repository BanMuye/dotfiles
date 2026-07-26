vim.pack.add({
	{
		src = "https://github.com/nvim-tree/nvim-web-devicons.git",
		name = "nvim-web-devicons",
	},
	{
		src = "https://github.com/akinsho/bufferline.nvim.git",
		name = "bufferline",
	},
})

-- enable true-color support required by bufferline
vim.opt.termguicolors = true

require("bufferline").setup({
	options = {
		-- show open buffers instead of Neovim tabpages
		mode = "buffers",

		-- display lsp diagnostic counts on buffers
		diagnostics = "nvim_lsp",

		-- use slanted separators between buffers
		separator_style = "slant",

		-- hide the bufferline when one buffer is open
		always_show_bufferline = false,

		-- hide the close icon on every buffer
		show_buffer_close_icons = false,

		-- hide the global close button
		show_close_icon = false,

		-- show indicators for tabpages when they exist
		show_tab_indicators = true,
	},
})
