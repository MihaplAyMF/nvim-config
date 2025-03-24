
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

vim.g.mapleader = " "
vim.o.foldmethod = 'indent'
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

function GetGameNameFromCmake()
  local cmake_file = vim.fn.getcwd() .. "/CMakeLists.txt"
  local game_name = ""

  if vim.fn.filereadable(cmake_file) == 1 then
    local cmake_content = vim.fn.readfile(cmake_file)
    for _, line in ipairs(cmake_content) do
      if line:match("project%s*%((%w+)%)") then
        game_name = line:match("project%s*%((%w+)%)")
        break
      end
    end
  end

  return game_name
end

vim.api.nvim_create_user_command('Run', function()

    if not build_dir then
        print("❌ Directory src not found!")
        return
    end

    local cmake_file = build_dir .. "/CMakeLists.txt"
    local game_name = ""

    if vim.fn.filereadable(cmake_file) == 1 then
        local cmake_content = vim.fn.readfile(cmake_file)

        for _, line in ipairs(cmake_content) do
            if line:match("project%s*%((%w+)%)") then
                game_name = line:match("project%s*%((%w+)%)")
                break
            end
        end
    end

    local exec_path = build_dir .. "/build/" .. game_name

    if vim.fn.filereadable(exec_path) == 1 then
        vim.fn.system("cd " .. build_dir .. "/build && ./" .. game_name)
        print("✅ Game " .. game_name .. " run!")
    else
        print("❌ Executable file " .. exec_path .. " not found!")
    end
end, {})
