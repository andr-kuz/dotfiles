return {
    {
        "mfussenegger/nvim-dap"
    },
    {
        "mfussenegger/nvim-lua-debugger",
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui"
        },
        config = function(_, opts)
            require('dap-python').setup('~/.debugpy/bin/python')
            local dap = require("dap")
            if dap.configurations.python then
                for _, config in ipairs(dap.configurations.python) do
                    config.justMyCode = false
                end
            end
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(
                {
                    controls = {
                      element = "repl",
                      enabled = false,
                    },
                    layouts = {
                        {
                            elements = {
                                {
                                    id = "repl",
                                    size = 0.5
                                },
                                {
                                    id = "console",
                                    size = 0.5
                                }
                            },
                            position = "bottom",
                            size = 10
                        },
                        {
                            elements = {
                                {
                                    id = "scopes",
                                }
                            },
                            position = "bottom",
                            size = 10
                        }
                    }
                }
            )
            dap.listeners.after.event_initialized.dapui_config = function()
                dapui.open()
            end
        end
    }
}
