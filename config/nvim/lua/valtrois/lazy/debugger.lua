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
            local python_path = vim.fn.system('type -a python')
            local global_python_path = python_path:match('\npython is (/.*)\n$')
            require('dap-python').setup(global_python_path)
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
            -- dap.configurations.python = {
            --     {
            --         justMyCode = false,
            --         type = "python",
            --         request = 'launch',
            --         name = 'launch file',
            --         program = '${file}',
            --         pythonPath = function()
            --             local venv_path = os.getenv("VIRTUAL_ENV")
            --             if venv_path then
            --             return venv_path .. "/bin/python"
            --             end
            --             return "/usr/bin/python3"
            --         end
            --     },
            -- }
        end
    }
}
