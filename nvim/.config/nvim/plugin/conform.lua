vim.pack.add({
    {
        src = "https://github.com/stevearc/conform.nvim.git",
        name = "conform"
    }
})

require("conform").setup({
    formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },

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
    }
})

