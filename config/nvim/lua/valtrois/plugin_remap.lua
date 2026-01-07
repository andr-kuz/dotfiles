local dap = require('dap')
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>r', dap.continue)
vim.keymap.set('n', '<leader>c', dap.continue)
vim.keymap.set('n', '<leader>i', dap.step_into)
vim.keymap.set('n', '<leader>o', dap.step_out)
vim.keymap.set('n', '<leader>n', dap.step_over)
vim.keymap.set('n', '<leader>x', dap.close)
vim.keymap.set('n', '<leader>X', '<Cmd>lua require("dap").disconnect()<CR><Cmd>lua require("dapui").close()<CR>')

local dap_python = require('dap-python')
vim.keymap.set('n', '<leader>dn', dap_python.test_method)


vim.keymap.set('n', 'gv', '<Cmd>vs<CR><Cmd>lua require("telescope.builtin").lsp_definitions()<CR>', { desc = '[G]oto definition in [V]split' })
vim.keymap.set('n', 'gs', '<Cmd>sp<CR><Cmd>lua require("telescope.builtin").lsp_definitions()<CR>', { desc = '[G]oto definition in [S]plit' })
