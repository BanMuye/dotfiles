local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show messages
}

local opt_function = function(desc)
	return {
		noremap = opts.noremap,
		silent = opts.silent,
		desc = desc,
	}
end

-------------------
--- Normal Mode ---
-------------------

-- Buffer Actions
vim.keymap.set("n", "<leader>bd", "<CMD>bdelete<CR>", opt_function("Delete curernt buffer"))

-- Tab Actions
vim.keymap.set("n", "<leader>tn", "<CMD>tabnew<CR>", opt_function("Create new tab"))
vim.keymap.set("n", "<leader>tc", "<CMD>tabclose<CR>", opt_function("Close current tab"))

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows, delta two lines
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Better move head and tail
vim.keymap.set("n", "gh", "^", opts)
vim.keymap.set("n", "gl", "$", opts)

------------------
--- Insert Mode---
------------------

--------------------
--- Virtual Mode ---
--------------------

-- Move Text
vim.keymap.set("v", "<C-j>", ":move '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<C-k>", ":move '<-2<CR>gv=gv", opts)
