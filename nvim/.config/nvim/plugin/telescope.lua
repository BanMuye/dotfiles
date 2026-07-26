vim.pack.add({
	{
		src = "https://github.com/nvim-lua/plenary.nvim.git",
		name = "plenary",
	},
	{
		src = "https://github.com/nvim-telescope/telescope.nvim.git",
		name = "telescope",
	},
})

require("telescope").setup()

local builtin = require("telescope.builtin")
local opts = function(desc)
	return {
		silent = true,
		noremap = true,
		desc = desc,
	}
end

vim.keymap.set("n", "<leader>ff", builtin.find_files, opts("Find files"))
vim.keymap.set("n", "<leader>fg", builtin.live_grep, opts("Search text in files"))
vim.keymap.set("n", "<leader>fb", builtin.buffers, opts("Find open buffers"))
vim.keymap.set("n", "<leader>fc", builtin.command_history, opts("Find command history"))
vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts("Find help tags"))
