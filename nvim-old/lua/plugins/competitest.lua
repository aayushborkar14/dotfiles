return {
  "xeluxee/competitest.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  config = function()
    require("competitest").setup({
      template_file = {
        cpp = "/home/aayush/codeforces/template.cpp",
      },
      compile_command = {
        c = { exec = "gcc", args = { "-Wall", "-g", "$(FNAME)", "-o", "$(FNOEXT)", "-ftrapv" } },
        cpp = { exec = "g++", args = { "-Wall", "-g", "$(FNAME)", "-o", "$(FNOEXT)", "-ftrapv" } },
        rust = { exec = "rustc", args = { "$(FNAME)" } },
        java = { exec = "javac", args = { "$(FNAME)" } },
      },
      -- testcases_input_file_format = "input$(TCNUM)",
      -- testcases_output_file_format = "output$(TCNUM)",
    })
  end,
  keys = {
    { "<leader>ctt", "<cmd>CompetiTest receive testcases<cr>", desc = "Receive testcases" },
    { "<leader>ctp", "<cmd>CompetiTest receive problem<cr>", desc = "Receive problems" },
    { "<leader>ctc", "<cmd>CompetiTest receive contest<cr>", desc = "Receive contest" },
    { "<leader>ctr", "<cmd>CompetiTest run<cr>", desc = "Run testcases" },
  },
}
