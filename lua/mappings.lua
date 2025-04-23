require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<Leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Toggle breakpoint" })
map("n", "<Leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue debugger" })
map("n", "<Leader>ds", "<cmd> DapStepOver <CR>", { desc = "Step over" })
map("n", "<Leader>di", "<cmd> DapStepInto <CR>", { desc = "Step into" })
map("n", "<Leader>do", "<cmd> DapStepOut <CR>", { desc = "Step out" })
map("n", "<Leader>dp", "<cmd> DapPause <CR>", { desc = "Pause debugger" })
map("n", "<Leader>dx", "<cmd> DapTerminate <CR>", { desc = "Terminate debugger" })

