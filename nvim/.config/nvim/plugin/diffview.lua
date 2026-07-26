vim.pack.add({
	{
		src = "https://github.com/sindrets/diffview.nvim.git",
		name = "diffview",
	},
})

require("diffview").setup()

vim.keymap.set("n", "<leader>gd", "<CMD>DiffviewOpen<CR>", {
	silent = true,
	noremap = true,
	desc = "Open Git diff view",
})

vim.keymap.set("n", "<leader>gh", "<CMD>DiffviewFileHistory %<CR>", {
	silent = true,
	noremap = true,
	desc = "Show current file Git history",
})
