vim.cmd("colorscheme sorbet")
-- vim.cmd("highlight Normal guibg=NONE") -- inherits terminal window transparency
-- vim.cmd("highlight NormalFloat guibg=NONE") -- transparency for floating windows

vim.opt.number = false
vim.opt.relativenumber = true
-- relativenumber starts with `2`
vim.opt.statuscolumn = "%= %{v:relnum == 0 ? v:lnum : (v:relnum + 1)} "
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true  -- copy indent from the current line

vim.opt.clipboard = 'unnamedplus'

-- restrict vim from hiding some markup symbols like `__text__` in markdown files
vim.opt.conceallevel = 1

vim.opt.swapfile = false
vim.opt.backup = false

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.updatetime = 200
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.autochdir = false  -- don't auto change directory

-- adds syntax errors etc
vim.diagnostic.config({ virtual_text = true })

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('UserConfig', {})

autocmd('TextYankPost', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 80,
    })
  end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Create directories when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
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

vim.opt.scrolloff = 8 -- how many lines above/below the cursor
-- the function below keeps scrolloff working even at the end of the file
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("ScrollOffEOF", {}),
    callback = function()
        local win_h = vim.api.nvim_win_get_height(0)
        local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
        local dist = vim.fn.line "$" - vim.fn.line "."
        local rem = vim.fn.line "w$" - vim.fn.line "w0" + 1
        if dist < off and win_h - rem + dist < off then
            local view = vim.fn.winsaveview()
            view.topline = view.topline + off - (win_h - rem + dist)
            vim.fn.winrestview(view)
        end
    end,
})
