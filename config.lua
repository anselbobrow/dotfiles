-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.colorscheme = "retrobox"
lvim.transparent_window = true

lvim.plugins = {
	{
		"ggandor/leap.nvim",
		name = "leap",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{ "tpope/vim-abolish" },
	{ "tpope/vim-surround" },
}

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{
		name = "prettier",
		filetypes = { "typescript", "typescriptreact" },
	},
	{ name = "stylua" },
})

lvim.keys.normal_mode["<C-h>"] = false
lvim.keys.normal_mode["<C-j>"] = false
lvim.keys.normal_mode["<C-k>"] = false
lvim.keys.normal_mode["<C-l>"] = false
lvim.keys.normal_mode["<M-h>"] = false
lvim.keys.normal_mode["<M-j>"] = false
lvim.keys.normal_mode["<M-k>"] = false
lvim.keys.normal_mode["<M-l>"] = false

lvim.keys.normal_mode["<S-l>"] = "<cmd>BufferLineCycleNext<cr>"
lvim.keys.normal_mode["<S-h>"] = "<cmd>BufferLineCyclePrev<cr>"
lvim.keys.normal_mode["<M-C-j>"] = ":m .+1<CR>=="
lvim.keys.normal_mode["<M-C-k>"] = ":m .-2<CR>=="

vim.opt.relativenumber = true
