local vim = vim -- suppress lsp warnings
local keymap = vim.keymap

vim.lsp.enable({
  "pyright", -- npm i -g pyright
  "copilot", -- npm i -g @github/copilot-language-server
  "lua_ls",
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Enable auto-completion.
    if client:supports_method('textDocument/completion') then
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    -- Enable inline auto-completion.
    if client:supports_method('textDocument/inlineCompletion') then
      vim.lsp.inline_completion.enable(true)
      keymap.set("i", "<Tab>", function()
          return vim.lsp.inline_completion.get() and nil or "<Tab>"
        end,
        { desc = "Apply inline completion if visible" }
      )
    end

    -- Auto-format ("lint") on save.
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
