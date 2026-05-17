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

vim.keymap.set("n", "<F2>", function()
  dap.continue()
end, { desc = "Debug continue" })

vim.keymap.set("n", "<F3>", function()
  dapui.close()
end, { desc = "Debug UI close" })

vim.keymap.set("n", "<F1>", function()
  dap.toggle_breakpoint()
end, { desc = "Debug breakpoint" })

vim.keymap.set("n", "<F5>", function()
  dap.step_over()
end, { desc = "Debug next" })

vim.keymap.set("n", "<F4>", function()
  dap.step_into()
end, { desc = "Debug into" })
