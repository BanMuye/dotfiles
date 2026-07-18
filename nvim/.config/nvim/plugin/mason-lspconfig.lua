vim.pack.add({
    { src = "https://github.com/mason-org/mason-lspconfig.nvim.git"}
})

local servers = {
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
