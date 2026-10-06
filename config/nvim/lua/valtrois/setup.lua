vim.cmd("colorscheme sorbet")
-- vim.cmd("highlight Normal guibg=NONE") -- inherits terminal window transparency
-- vim.cmd("highlight NormalFloat guibg=NONE") -- transparency for floating windows

vim.opt.number = true
vim.opt.relativenumber = true
-- relativenumber starts with `2`
-- vim.opt.statuscolumn = "%s%= %{v:relnum == 0 ? v:lnum : (v:relnum + 1)} "
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true  -- copy indent from the current line

vim.opt.clipboard = 'unnamedplus'

-- restrict vim from hiding some markup symbols like `__text__` in markdown files
vim.opt.conceallevel = 2

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

vim.opt.scrolloff = 999  -- Keeps the cursor vertically centered
vim.opt.scrolloffpad = 1 -- Allows the centering behavior at the end of the buffer

vim.api.nvim_create_user_command('CreatePaddings', function(args)
  -- close old flagged buffs first
  local current_tab = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(current_tab)

  for _, win in ipairs(wins) do
    if vim.api.nvim_win_is_valid(win) and vim.w[win].is_padding then
      vim.api.nvim_win_close(win, true)
    end
  end

  -- create new buffs
  local width = 5
  if args.fargs and #args.fargs > 0 then
    width = tonumber(args.fargs[1]) or width
  end

  for _, side in ipairs({'left', 'right'}) do
    local direction = (side == 'right') and 'rightbelow' or 'leftabove'
    local width = (side == 'left') and width - 3 or width
    vim.cmd(direction .. ' ' .. width .. 'vnew')
    local pad_win = vim.api.nvim_get_current_win()
    vim.w[pad_win].is_padding = true
    vim.cmd('setlocal bufhidden=wipe buftype=nofile noswapfile winfixwidth')
    vim.cmd('set nonumber')
    vim.cmd('set norelativenumber')
    -- vim.cmd('set laststatus=0')

    vim.api.nvim_create_autocmd("WinEnter", {
      callback = function(_)
        if not vim.api.nvim_win_is_valid(pad_win) then
          return true
        end

        if vim.api.nvim_get_current_win() == pad_win then
          if side == 'right' then
            vim.cmd('wincmd h')
          else
            vim.cmd('wincmd l')
          end
        end
      end,
    })

    if side == 'right' then
      vim.cmd('wincmd h')
    else
      vim.cmd('wincmd l')
    end
  end
end, {
  nargs = '*',
})

vim.api.nvim_create_user_command('Zen', function(args)
  local width = 5
  if args.fargs and #args.fargs > 0 then
    width = tonumber(args.fargs[1]) or width
  end
  print(width)
  vim.cmd('CreatePaddings ' .. width)

  if vim.wo.number then
    vim.wo.signcolumn = 'no'
    vim.opt.cursorline = false
    vim.opt.statuscolumn = ''
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.cmd('colorscheme retrobox')
    vim.cmd('highlight WinSeparator guibg=NONE guifg=NONE')
    vim.opt.fillchars = {
      vert = ' ',
      horiz = ' ',
      horizup = ' ',
      horizdown = ' ',
      vertleft = ' ',
      vertright = ' ',
      verthoriz = ' ',
      eob = ' ',
    }
  end
end, {
  nargs = '*',
})
