vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/nvim-neotest/nvim-nio",
})

local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DapStopped", linehl = "", numhl = "" })
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff5f56" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#e5c07b" })

dap.set_log_level("TRACE")

dap.adapters.gdb = {
  id = "gdb",
  type = "executable",
  command = "C:/msys64/ucrt64/bin/gdb.exe",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}

dap.configurations.cpp = {
  {
    name = "Debug x64 Debug",
    type = "gdb",
    request = "launch",
    program = function()
      local exes = vim.fn.glob("bin/x64/Debug/*.exe", false, true)
      if #exes == 0 then
        error("No .exe found. Run scripts\\debug-build.bat first.")
      end
      return vim.fs.normalize(vim.fn.getcwd() .. "/" .. exes[1])
    end,
    args = {},
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
}

dap.configurations.c = dap.configurations.cpp

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set("n", "<leader>ms", function()
  dapui.open()
  dap.continue()
end, { desc = "Debug start/continue" })

vim.keymap.set("n", "<leader>mx", function()
  dapui.toggle()
end, { desc = "Debug UI toggle" })

vim.keymap.set("n", "<leader>mr", function()
  dapui.open()
  dap.restart()
end, { desc = "Debug restart" })

vim.keymap.set("n", "<leader>mq", function()
  dap.terminate()
  dapui.close()
end, { desc = "Debug stop" })

vim.keymap.set("n", "<leader>mb", function()
  dap.toggle_breakpoint()
end, { desc = "Debug breakpoint" })

vim.keymap.set("n", "<leader>mn", function()
  dap.step_over()
end, { desc = "Debug step over" })

vim.keymap.set("n", "<leader>mi", function()
  dap.step_into()
end, { desc = "Debug step into" })

vim.keymap.set("n", "<leader>mo", function()
  dap.step_out()
end, { desc = "Debug step out" })
