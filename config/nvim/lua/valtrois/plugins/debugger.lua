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
        dap.terminate()
        require('dapui').close()
      end)

      vim.api.nvim_create_autocmd('QuitPre', {
        group = vim.api.nvim_create_augroup('DapCloseOnExit', { clear = true }),
        callback = function()
          local ok, dapui = pcall(require, 'dapui')
          if ok then
            dapui.close()
          end

          dap.terminate()

          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) then
              local name = vim.api.nvim_buf_get_name(buf)
              local ft = vim.bo[buf].filetype
              if ft == 'dap-terminal' or ft:match('^dapui') or name:match('%[dap%-terminal%]') then
                pcall(vim.api.nvim_buf_delete, buf, { force = true })
              end
            end
          end
        end,
      })

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
