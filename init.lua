
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

vim.wo.relativenumber = true
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"
require "configs.dap"

vim.schedule(function()
  require "mappings"
end)

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.g.neomake_cpp_enabled_makers = {'g++'}

local cwd = vim.fn.getcwd()
local build_dir = cwd:match("^(.*)/src") or cwd:match("^(.*)/src/.*")

if build_dir then
    vim.cmd("set makeprg=cmake\\ --build\\ " .. build_dir .. "/build")
end

vim.api.nvim_create_user_command('Run', function()

    if not build_dir then
        print("❌ Directory src not found!")
        return
    end

    local nvim_paths_file = build_dir .. "/.nvim_paths"
    local paths = vim.fn.readfile(nvim_paths_file)
    local exec_path = paths[1]
    local project_name = paths[2]

    if vim.fn.filereadable(exec_path .. project_name) == 1 then
        vim.fn.system("cd " .. exec_path .. " && ./" .. project_name)
        print("✅ Project run!")
    else
        print("❌ Executable file " .. exec_path .. project_name .. " not found!")
    end

end, {})
