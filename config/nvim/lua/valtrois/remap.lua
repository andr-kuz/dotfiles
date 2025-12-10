vim.g.mapleader = ' '

vim.keymap.set({'n', 'v'}, '<leader>y', 'y')
vim.keymap.set({'n', 'v'}, '<leader>Y', 'y$')
vim.keymap.set({'n', 'v'}, 'y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({'n', 'v'}, 'Y', '"+y$', { desc = 'Yank line to system clipboard' })

vim.keymap.set({'n', 'x'}, 'd', '"_d')
vim.keymap.set({'n', 'x'}, 'D', '"_D')
vim.keymap.set({'n', 'x'}, 'x', '"_x')
vim.keymap.set({'n', 'x'}, 'c', '"_c')
vim.keymap.set({'n', 'n'}, 'C', '"_C')
vim.keymap.set({'n', 'x'}, '<leader>d', 'd')

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>t', '<Cmd>horizontal terminal<CR>i')

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<A-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
vim.keymap.set('t', '<A-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
vim.keymap.set('t', '<A-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
vim.keymap.set('t', '<A-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })
vim.keymap.set('t', '<C-x>', '<Cmd>bd!', { noremap = true, silent = true })

vim.keymap.set('i', '<A-h>', '<C-n><C-w>hi', { noremap = true, silent = true })
vim.keymap.set('i', '<A-j>', '<C-n><C-w>ji', { noremap = true, silent = true })
vim.keymap.set('i', '<A-k>', '<C-n><C-w>ki', { noremap = true, silent = true })
vim.keymap.set('i', '<A-l>', '<C-n><C-w>li', { noremap = true, silent = true })

vim.keymap.set('n', '<A-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<A-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<A-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>e', '<Cmd>Ex<CR>')
vim.keymap.set('n', '<leader>E', '<Cmd>vsplit ' .. vim.fs.dirname(vim.fn.expand('$MYVIMRC')) .. '/lua/valtrois/remap.lua<CR><Cmd>setlocal bufhidden=wipe<CR><Cmd>lcd %:p:h<CR>')
vim.keymap.set('n', '<leader>V', '<Cmd>vsplit ~/zettelkasten/Vim.md<CR><Cmd>setlocal bufhidden=wipe<CR><Cmd>lcd %:p:h<CR>')
vim.keymap.set('n', '<leader>q', 'q', { noremap = true, silent = true })

-- treat ctrl-c as esc
vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', '<C-a>', '<Esc>la', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = "*.md",
    callback = function()
        -- Only set the mappings if they don't exist already
        local opts = { buffer = true, noremap = true, desc = 'Insert > on the line start in markdown and return back to `x` mark' }
        vim.keymap.set('n', '>', 'mxI> <Esc>`xll', opts)
        vim.keymap.set('n', '<', 'mxI> <Esc>`xll', opts)
    end
})
