local vim = vim -- suppress lsp warnings
local o = vim.opt
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.wrap = false
o.autoread = true
o.shell = "fish"
o.wildmode = { "lastused", "full" }
o.autocomplete = true
o.completeopt = { "menu", "noinsert" }
o.pumheight = 5
o.number = true
o.relativenumber = true
o.cmdheight = 0
o.signcolumn = "yes"
o.laststatus = 3
o.winborder = "rounded"
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.swapfile = false
o.foldmethod = "indent"
o.foldlevelstart = 99
o.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.clipboard:append("unnamedplus")

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Save file
keymap.set('n', '<C-s>', '<cmd>w<CR>', opts)
keymap.set('i', '<C-s>', '<Esc><cmd>w<CR>', opts)

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

-- Buffers
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", opts)
keymap.set("n", "H", "<cmd>bprevious<CR>", opts)
keymap.set("n", "L", "<cmd>bnext<CR>", opts)

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

vim.pack.add({
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/linux-cultist/venv-selector.nvim",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.surround"
})

require("vim._extui").enable({}) -- https://github.com/neovim/neovim/pull/27855
require("plugins.lsp")
require("rose-pine").setup({ styles = { transparency = true } })
vim.cmd("colorscheme rose-pine")
require("plugins.snacks")
require("lualine").setup({
  sections = {
    lualine_z = {
      function()
        return " " .. os.date("%R")
      end,
    },
  }
})
require("bufferline").setup({
  options = {
    always_show_bufferline = false,
    offsets = {
      {
        filetype = "snacks_layout_box",
        separator = true,
      },
    },
  }
})
require("venv-selector").setup({
  default = "venv",
})
keymap.set("n", "<leader>cv", "<cmd>VenvSelect<CR>", opts)
require("mini.pairs").setup()
require("mini.surround").setup()
require("plugins.competitest")
require("plugins.dap")
