vim.wo.number = true
vim.wo.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.clipboard = 'unnamedplus'

-- restrict vim from hiding some markup symbols like `__text__` in markdown files
vim.opt.conceallevel = 0

vim.opt.swapfile = false
vim.opt.backup = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.updatetime = 200
vim.opt.splitright = true
vim.opt.splitbelow = true

-- adds syntax errors etc
vim.diagnostic.config({ virtual_text = true })

local autocmd = vim.api.nvim_create_autocmd
local yank_group = vim.api.nvim_create_augroup('HighlightYank', {})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 80,
        })
    end,
})


-- This needs for a 'Pocco81/auto-save.nvim' plugin not conflict with a 'epwalsh/obsidian.nvim' plugin when you undo
vim.cmd[[autocmd TextChanged,FocusLost,BufEnter * if &buftype ==# '' || &buftype == 'acwrite' | silent update | endif]]

-- do not treat _ as part of the word
-- vim.opt.iskeyword:remove("_")

-- treat `.keymap` files as c-like
vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*.keymap',  -- Or "corne.keymap" for the specific file
  command = 'set filetype=c',  -- Change "c" to match your file type (e.g., "json")
})

-- Create undo directory if it doesn't exist (required for persistent undo)
if vim.fn.isdirectory(vim.env.HOME .. '/.local/state/nvim/undo') == 0 then
  vim.fn.mkdir(vim.env.HOME .. '/.local/state/nvim/undo', "p")
end

-- Persistent undo/redo history: Persist the undo tree for each file across sessions
vim.opt.undofile = true  -- Enable persistent undo files
vim.opt.undodir:prepend(vim.fn.expand('~/.local/state/nvim/undo//'))  -- Set directory for undo tree files

vim.filetype.add({
  extension = {
    keymap = "c",  -- Treat .keymap as C files
  },
})

vim.g.netrw_banner = 0  -- disable file explorer banner
