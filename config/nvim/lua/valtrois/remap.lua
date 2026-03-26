vim.g.mapleader = ' '

local map = vim.keymap.set

map('n', ';', 'q:')

map({'n', 'v'}, '<leader>y', 'y')
map({'n', 'v'}, '<leader>Y', 'y$')
map({'n', 'v'}, 'y', '"+y', { desc = 'Yank to system clipboard' })
map({'n', 'v'}, 'Y', '"+y$', { desc = 'Yank line to system clipboard' })

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map({'n', 'x'}, 'd', '"_d')
map({'n', 'x'}, 'D', '"_D')
map({'n', 'x'}, 'x', '"_x')
map({'n', 'x'}, 'c', '"_c')
map({'n', 'n'}, 'C', '"_C')
map({'n', 'x'}, '<leader>d', 'd')

map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

map('n', '<leader>t', '<Cmd>horizontal terminal<CR>i')

map('t', '<Esc>', '<C-\\><C-n>')
map('t', '<A-h>', '<C-\\><C-n><C-w>h', { noremap = true, silent = true })
map('t', '<A-j>', '<C-\\><C-n><C-w>j', { noremap = true, silent = true })
map('t', '<A-k>', '<C-\\><C-n><C-w>k', { noremap = true, silent = true })
map('t', '<A-l>', '<C-\\><C-n><C-w>l', { noremap = true, silent = true })
map('t', '<C-d>', '<Cmd>bd!', { noremap = true, silent = true })

map('i', '<A-h>', '<C-o><C-w>h', { noremap = true, silent = true })
map('i', '<A-j>', '<C-o><C-w>j', { noremap = true, silent = true })
map('i', '<A-k>', '<C-o><C-w>k', { noremap = true, silent = true })
map('i', '<A-l>', '<C-o><C-w>l', { noremap = true, silent = true })

map('n', '<A-h>', '<C-w>h', { noremap = true, silent = true })
map('n', '<A-j>', '<C-w>j', { noremap = true, silent = true })
map('n', '<A-k>', '<C-w>k', { noremap = true, silent = true })
map('n', '<A-l>', '<C-w>l', { noremap = true, silent = true })

map('n', '<leader>e', '<Cmd>Ex<CR>')
map('n', '<leader>E', '<Cmd>vsplit ' .. vim.fs.dirname(vim.fn.expand('$MYVIMRC')) .. '/lua/valtrois/remap.lua<CR><Cmd>setlocal bufhidden=wipe<CR><Cmd>lcd %:p:h<CR>')
map('n', '<leader>V', '<Cmd>vsplit ~/zettelkasten/Vim.md<CR><Cmd>setlocal bufhidden=wipe<CR><Cmd>lcd %:p:h<CR>')
map('n', '<leader>q', 'q', { noremap = true, silent = true })

-- treat ctrl-c as esc
vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('BufEnter', {
    pattern = "*.md",
    callback = function()
        -- Only set the mappings if they don't exist already
        local opts = { buffer = true, noremap = true, desc = 'Insert > on the line start in markdown and return back to `x` mark' }
        vim.keymap.set('n', '>', 'mxI> <Esc>`xll', opts)
        vim.keymap.set('n', '<', 'mxI> <Esc>`xll', opts)
    end
})
