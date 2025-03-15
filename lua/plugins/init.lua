return {
    {
        "stevearc/conform.nvim",
        opts = require "configs.conform",
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("configs.lspconfig")
        end
    },
    {
        "williamboman/mason.nvim",
        config = function()
	        require("mason").setup()
	    end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
            })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mfussenegger/nvim-dap", "williamboman/mason.nvim" },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb" },
                automatic_setup = true,
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies =
        {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            require("dapui").setup()
            require("nvim-dap-virtual-text").setup()
        end,
    },
    { "tpope/vim-commentary" },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                cpp = { "clangtidy" },
            }
        end,
    },
}
