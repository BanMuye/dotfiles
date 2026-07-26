--------------
---Diagnose---
--------------
vim.diagnostic.config({
	-- sort by error degree
	severity_sort = true,

	-- update after quiting INSERT mode
	update_in_insert = false,

	-- underline error
	underline = true,

	-- show signs in left column
	signs = true,

	-- show error info at the end of line
	virtual_text = {
		spacing = 2,
		source = "if_many",
		prefix = "●",
	},

	-- floating style
	float = {
		border = "rounded",
		source = true,
		header = "",
	},
})

------------
---Keymap---
------------
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-keymap", {
		clear = true,
	}),

	callback = function(event)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
			buffer = event.buf,
			silent = true,
			noremap = true,
			desc = "LSP: Go to definition",
		})
	end,
})

local servers = {
	"bashls",
	"jdtls",
	"pyright",
	"rust_analyzer",
	"ts_ls",
	"html",
	"cssls",
	"lua_ls",
}

require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = servers,
})
