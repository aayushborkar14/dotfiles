local vim = vim -- suppress lsp warnings
local o = vim.opt
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.smartindent = true
o.wrap = false
o.autoread = true
o.cursorline = true
o.smoothscroll = true
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
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.smartcase = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard:append("unnamedplus")

-- User Commands

-- Create a new buffer and run shell command
vim.api.nvim_create_user_command("ShellOut", function(opts)
  local cmd = table.concat(opts.fargs, " ")

  -- create and switch to a new buffer
  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()

  -- buffer options
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false

  -- set buffer name
  vim.api.nvim_buf_set_name(buf, "[shell] " .. cmd)

  -- start async job
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,

    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
      end
    end,
  })
end, { nargs = "+" })

-- Keymaps

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
  vim.diagnostic.jump({ count = 1, float = true })
end, opts)

keymap.set("n", "<C-k>", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, opts)

-- Stop search and clear highlighting on escape
keymap.set("i", "<Esc>", "<cmd>noh<CR><Esc>", opts)
keymap.set("n", "<Esc>", "<cmd>noh<CR><Esc>", opts)
keymap.set("s", "<Esc>", "<cmd>noh<CR><Esc>", opts)

-- Auto commands

-- Resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Fix conceal level for json files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create directories when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Plugins

vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/kepano/flexoki-neovim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/zbirenbaum/copilot.lua",
  "https://github.com/AndreM222/copilot-lualine",
  "https://github.com/MunifTanjim/nui.nvim",
})

require("plugins.lsp")
require("tokyonight").setup({
  transparent = true,
})
-- vim.cmd("colorscheme tokyonight-night")
vim.cmd("colorscheme flexoki-dark")
require("plugins.snacks")
require("lualine").setup({
  sections = {
    lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
    lualine_y = {
      { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
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
require("copilot").setup({
  suggestion = {
    auto_trigger = true,
    hide_during_completion = false,
    keymap = {
      accept = false,
      accept_word = "<C-l>"
    }
  }
})
keymap.set("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    return require("copilot.suggestion").accept()
  else
    return "<Tab>"
  end
end, { expr = true, noremap = true })

require("mini.pairs").setup()
require("mini.surround").setup({
  mappings = { highlight = "" }
})
require("plugins.competitest")
require("plugins.dap")
