local dap = require("dap")
local dapui = require("dapui")

dapui.setup();
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.launch["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set('n', '<F1>', function() dap.continue() end)
vim.keymap.set('n', '<F2>', function() dap.step_into() end)
vim.keymap.set('n', '<F3>', function() dap.step_over() end)
vim.keymap.set('n', '<F4>', function() dap.step_out() end)
vim.keymap.set('n', '<F5>', function() dap.step_back() end)
vim.keymap.set('n', '<F12>', function() dap.restart() end)
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() dap.set_breakpoint() end)

require('dap-go').setup()
require('dap.ext.vscode').load_launchjs()
