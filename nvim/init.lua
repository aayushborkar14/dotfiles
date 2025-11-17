local vim = vim -- suppress lsp warnings
local o = vim.opt
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.wrap = false
o.autoread = true
o.backspace = "indent,eol,start"
o.shell = "fish"
o.colorcolumn = "100"
o.completeopt = { "menuone", "noselect", "popup" }
o.wildmode = { "lastused", "full" }
o.pumheight = 15
o.number = true
o.relativenumber = true
o.cmdheight = 0
o.signcolumn = "yes"
o.winborder = "rounded"
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.swapfile = false
o.foldmethod = "indent"
o.foldlevelstart = 99
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Save file
keymap.set('n', '<C-s>', '<cmd>w<CR>', opts)
keymap.set('i', '<C-s>', '<Esc><cmd>w<CR>a', opts)

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", "vb_d")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "C-w>+")
keymap.set("n", "<C-w><down>", "C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

local augroup = vim.api.nvim_create_augroup("this.cfg", { clear = true })
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

local function setup_lsp()
	vim.lsp.enable({
		"pyright", -- npm i -g pyright
	})

	autocmd("LspAttach", {
		group = augroup,
		callback = function(ev)
			local bufopts = { noremap = true, silent = true, buffer = ev.buf }
			map("n", "grd", vim.lsp.buf.definition, bufopts)
			map("i", "<C-k>", vim.lsp.completion.get, bufopts) -- open completion menu manually
			local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
			local methods = vim.lsp.protocol.Methods
			if client:supports_method(methods.textDocument_completion) then
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			end
		end,
	})
end

vim.pack.add({
	"https://github.com/rose-pine/neovim",
  "https://github.com/folke/snacks.nvim",
})

require("rose-pine").setup({ styles = { transparency = true } })
vim.cmd("colorscheme rose-pine")
require("vim._extui").enable({}) -- https://github.com/neovim/neovim/pull/27855
setup_lsp()
require("snacks_config")
