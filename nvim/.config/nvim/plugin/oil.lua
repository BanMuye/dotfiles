vim.pack.add({
    {
        src = "https://github.com/stevearc/oil.nvim.git",
        name = "oil",
    }
})

require("oil").setup()

vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", {
    silent = true,
    noremap = true,
    desc = "Open Oil",
})
