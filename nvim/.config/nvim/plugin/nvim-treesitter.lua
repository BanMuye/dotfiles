vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter.git",
		version = "main",
		name = "nvim-treesitter",
	},
})

local treesitter = require("nvim-treesitter")

treesitter.setup({})
treesitter.install({
	"back",
	"css",
	"html",
	"java",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rust",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
})

-- enable tree-sitter hightlight when open files
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter-start", {
		clear = true,
	}),
	callback = function(event)
		pcall(vim.treesiter.start, event.buf)
	end,
})
