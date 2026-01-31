local vim = vim -- suppress lsp warnings
local keymap = vim.keymap

vim.lsp.enable({
  "clangd",  -- sudo apt install clangd-18
  "jdtls",   -- brew install jdtls
  "lua_ls",  -- brew install lua-language-server
  "pyright", -- npm i -g pyright
  "ruff",    -- uv tool install ruff@latest
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

    -- Enable inline completion
    -- if client:supports_method('textDocument/inlineCompletion') then
    --   vim.lsp.inline_completion.enable(true)
    --   vim.keymap.set("i", "<Tab>", function()
    --       if not vim.lsp.inline_completion.get() then
    --         return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
    --       end
    --     end,
    --     { expr = true, desc = "Accept the current inline completion" }
    --   )
    --
    --   -- Toggle inline completion
    --   vim.keymap.set("n", "<leader>ui", function()
    --     local enabled = vim.lsp.inline_completion.is_enabled()
    --     vim.lsp.inline_completion.enable(not enabled)
    --     local status = enabled and "disabled" or "enabled"
    --     print("Inline completion " .. status)
    --   end, { desc = "Toggle inline completion" })
    -- end

    -- Auto-format ("lint") on save
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      -- Enable autoformat by default
      vim.b[args.buf].autoformat = true

      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          if vim.b[args.buf].autoformat then
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
          end
        end,
      })

      -- Keybind to toggle autoformat
      keymap.set("n", "<leader>uf", function()
        vim.b[args.buf].autoformat = not vim.b[args.buf].autoformat
        local status = vim.b[args.buf].autoformat and "enabled" or "disabled"
        print("Autoformat " .. status)
      end, { buffer = args.buf, desc = "Toggle autoformat" })

      -- Inlay Hints
      Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
        if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
        then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end)
    end
  end,
})
