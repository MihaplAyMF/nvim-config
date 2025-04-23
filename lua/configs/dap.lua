local dap = require("dap")
dap.set_log_level('DEBUG')

-- Налаштування адаптера для C++

local cwd = vim.fn.getcwd()
local build_dir = cwd:match("^(.*)/src") or cwd:match("^(.*)/src/.*")

if build_dir then
    vim.cmd("set makeprg=cmake\\ --build\\ " .. build_dir .. "/build")
end

--dap.adapters.cpp = {
--  type = 'executable',
--  command = 'gdb',  -- або 'lldb', якщо використовуєш lldb
--  args = {'--interpreter=mi'},
--}

dap.adapters.cpp = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = {"--port", "${port}"},
  }
}

-- Налаштування конфігурації для C++
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cpp",  -- Тип адаптера
        request = "launch",

        program = function()
            local nvim_paths_file = build_dir .. "/.nvim_paths"
            local paths = vim.fn.readfile(nvim_paths_file)
            local exec_path = paths[1]
            local project_name = paths[2]

            return vim.fn.input('Path to executable: ', exec_path .. project_name, 'file')
        end,

        cwd = '${workspaceFolder}',  -- Поточна робоча директорія
        stopAtEntry = true,          -- Зупинитись на початку програми
        setupCommands = {
          {
            description = "Enable pretty printing for gdb",
            text = "-enable-pretty-printing",
            done = false,
          },
        },
        MIMode = "gdb",  -- Вказуємо режим роботи gdb
        miDebuggerPath = "/usr/bin/gdb",  -- Шлях до gdb
    },
}


