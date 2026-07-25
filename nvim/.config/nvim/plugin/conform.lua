vim.pack.add({
	{
		src = "https://github.com/stevearc/conform.nvim.git",
		name = "conform",
	},
})

local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },

		lua = { "stylua" },

		python = { "ruff_format" },

		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		markdown = { "prettier" },

		rust = { "rustfmt" },
	},
})

vim.keymap.set("n", "<leader>cf", function()
	conform.format({
		async = true,
		lsp_format = "fallback",
	})
end, {
	silent = true,
	noremap = true,
	desc = "Format current buffer",
})
