return {
  {
    "mfussenegger/nvim-dap",
    config = function(_, opts)
      local dap = require('dap')
      local map = vim.keymap.set

      map('n', '<leader>b', dap.toggle_breakpoint)
      map('n', '<leader>r', dap.continue)
      map('n', '<leader>c', dap.continue)
      map('n', '<leader>i', dap.step_into)
      map('n', '<leader>o', dap.step_out)
      map('n', '<leader>n', dap.step_over)
      map('n', '<leader>x', dap.close)
      map('n', '<leader>X', function()
        dap.disconnect()
        dap.close()
      end)

      dap.adapters.lua = {
        type = 'server',
        host = '127.0.0.1',
        port = 8086,
      }

      dap.configurations.lua = {
        {
          type = 'lua',
          request = 'attach',
          name = 'Attach to running Neovim',
          port = 8086, -- Or your desired port
        },
        {
          type = 'lua',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
        },
      }
    end
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
      local map = vim.keymap.set
      local dap = require("dap")
      local dap_python = require('dap-python')

      map('n', '<leader>dn', dap_python.test_method)
      map('n', '<leader>dn', dap_python.test_method)

      dap_python.setup('~/.debugpy/bin/python') -- python -m venv ~/.debugpy && ~/.debugpy/bin/pip install debugpy

      if dap.configurations.python then
        for _, config in ipairs(dap.configurations.python) do
          config.justMyCode = true
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
