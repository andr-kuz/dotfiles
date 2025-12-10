require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = 'delete_buffer',
      },
    },
  },
}
pcall(require('telescope').load_extension, 'fzf')

require('dap').adapters.lua = {
  type = 'server',
  host = '127.0.0.1',
  port = 8086,
}

require('dap').configurations.lua = {
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
