local vim = vim -- suppress lsp warnings
vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/linux-cultist/venv-selector.nvim",
  "https://github.com/lervag/vimtex",
  "https://github.com/mrcjkb/rustaceanvim"
})
local keymap = vim.keymap
vim.g.vimtex_view_method = 'skim'

local treesitter_langs = {
  "c", "cpp", "java", "jsx", "javascript", "json", "lua", "markdown", "markdown_inline", "python", "rust", "go",
  "tsx", "typescript", "vimdoc", "vim"
}
require("nvim-treesitter").install(treesitter_langs)

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_langs,
  callback = function()
    vim.treesitter.start()
  end,
})

vim.lsp.enable({
  "clangd",  -- sudo apt install clangd-18
  "lua_ls",  -- brew install lua-language-server
  "gopls",   -- brew install gopls
  "pyright", -- npm i -g pyright
  "ruff",    -- uv tool install ruff@latest
  -- "rust-analyzer", -- brew install rust-analyzer
  "texlab",  -- brew install texlab
  "jdtls"    -- brew install jdtls
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Enable auto-completion
    if client:supports_method('textDocument/completion') then
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- Inlay Hints
    Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
      if
          vim.api.nvim_buf_is_valid(buffer)
          and vim.bo[buffer].buftype == ""
      then
        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
      end
    end)
  end,
})

require("conform").setup({
  formatters_by_ft = {
    java = { "google-java-format" }, -- brew install google-java-format
    javascript = { "prettierd" },    -- brew install prettierd
    javascriptreact = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    sql = { "pg_format" }, -- brew install pgformatter
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  }
})

require("venv-selector").setup({
  picker = "snacks"
})
keymap.set("n", "<leader>cv", "<cmd>VenvSelect<CR>", opts)
