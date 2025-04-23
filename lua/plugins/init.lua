return {
    {
        "nvim-neotest/nvim-nio"
    } ,
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
        opts = {
            ensure_installed =
            {
                "clangd",
                "clangd-format",
                "codelldb"
            }
        },
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
    { "tpope/vim-commentary" },
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                cpp = { "clangtidy" },
            }
        end,
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",  -- це плагін, що працює разом з nvim-dap
            "nvim-neotest/nvim-nio",  -- необхідний для роботи nvim-dap-ui
            "theHamsta/nvim-dap-virtual-text", -- допомагає виводити інформацію
        },
        config = function()
            -- Підключення nvim-dap і конфігурація для dapui та virtual-text
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            require("nvim-dap-virtual-text").setup()

            -- Настроювання слухачів для відкриття/закриття dapui при ініціалізації
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",  -- Плагін dapui для візуалізації відладчика
        event = "VeryLazy",  -- Підключається після певного часу або події
    },
}
