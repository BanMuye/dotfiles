vim.pack.add({
	{
		src = "https://github.com/lewis6991/gitsigns.nvim.git",
		name = "gitsigns",
	},
})

local gitsigns = require("gitsigns")

gitsigns.setup({
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, {
				buffer = bufnr,
				silent = true,
				noremap = true,
				desc = desc,
			})
		end

		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true }) -- use Neovim's built-in diff motion
			else
				gitsigns.nav_hunk("next")
			end
		end, "Next Git hunk")

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true }) -- use Neovim's built-in diff motion
			else
				gitsigns.nav_hunk("prev")
			end
		end, "Previous Git hunk")

		map("n", "<leader>hs", gitsigns.stage_hunk, "Stage Git hunk")
		map("n", "<leader>hr", gitsigns.reset_hunk, "Reset Git hunk")
		map("n", "<leader>hp", gitsigns.preview_hunk, "Preview Git hunk")
		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, "Blame current line")

		map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Git hunk")
	end,
})
