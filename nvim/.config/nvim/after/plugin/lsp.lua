
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("nvim-lspconfig").setup({})

local servers = {
    "bashls",
    "jdtls",
    "pyright",
    "rust_analyzer",
    "ts_ls",
    "html",
    "cssls",
}

require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = servers,
})
