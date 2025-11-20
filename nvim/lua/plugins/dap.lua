vim.pack.add({
  "https://codeberg.org/mfussenegger/nvim-dap",
  "https://codeberg.org/mfussenegger/nvim-dap-python",
  "https://github.com/igorlfs/nvim-dap-view"
})

vim.keymap.set("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  { desc = "Breakpoint Condition" })
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Run/Continue" })
vim.keymap.set("n", "<leader>da", function() require("dap").continue({ before = get_args }) end,
  { desc = "Run with Args" })
vim.keymap.set("n", "<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dg", function() require("dap").goto_() end, { desc = "Go to Line (No Execute)" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dj", function() require("dap").down() end, { desc = "Down" })
vim.keymap.set("n", "<leader>dk", function() require("dap").up() end, { desc = "Up" })
vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dO", function() require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dP", function() require("dap").pause() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>ds", function() require("dap").session() end, { desc = "Session" })
vim.keymap.set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })

require("dap-view").setup({ auto_toggle = true })

vim.keymap.set("n", "<leader>du", function() require("dap-view").toggle() end, { desc = "Toggle DAP View" })
vim.keymap.set("n", "<leader>dn", function() require("dap-view").navigate({ count = 1, wrap = true, type = "views" }) end,
  { desc = "Goto next DAP View" })
vim.keymap.set("n", "<leader>dp",
  function() require("dap-view").navigate({ count = -1, wrap = true, type = "views" }) end,
  { desc = "Goto previous DAP View" })

require("dap").adapters["codelldb"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = {
      "--port",
      "${port}",
    },
  },
}

for _, lang in ipairs({ "c", "cpp" }) do
  require("dap").configurations[lang] = {
    {
      type = "codelldb",
      request = "launch",
      name = "Launch file",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
    },
    {
      type = "codelldb",
      request = "attach",
      name = "Attach to process",
      pid = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
    },
  }
end

require("dap-python").setup("debugpy-adapter")
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.keymap.set("n", "<leader>dPt", function() require("dap-python").test_method() end,
      { desc = "Debug Method" })
    vim.keymap.set("n", "<leader>dPc", function() require("dap-python").test_class() end,
      { desc = "Debug Class" })
  end,
})
