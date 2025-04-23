require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls", "clangd" }

-- Определяем путь к compile_commands.json
local file_dir = vim.fn.expand('%:p:h')  -- Получаем директорию открытого файла
local project_root = file_dir:match("^(.*)/src/Code$")  -- Ищем корень проекта

local compile_commands_path = nil
if project_root and vim.fn.isdirectory(project_root .. "/src") == 1 then
    compile_commands_path = project_root .. "/build"
end

-- Настройки clangd
local clangd_opts = {
    cmd = {
        "clangd",
        compile_commands_path and "--compile-commands-dir=" .. compile_commands_path or nil,
    },
    settings = {
        clangd = {
            compileFlags = {
                Remove = { "-I/usr/include" },
            },
            PathExclude = {
                ".*%.inl$" 
            },
        },
        fallbackFlags = { "-std=c++17" },
    },
}

local function diagnostic_handler(_, result, ctx, config)
    if vim.fn.expand('%:e') == 'inl' then
        return
    end
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end

clangd_opts.handlers = {
    ["textDocument/publishDiagnostics"] = diagnostic_handler
}

for _, lsp in ipairs(servers) do
  if lsp == "clangd" then
    lspconfig[lsp].setup(vim.tbl_deep_extend("force", {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }, clangd_opts))
  else
    lspconfig[lsp].setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end
end
