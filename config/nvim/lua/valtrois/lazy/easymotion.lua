return {
  'smoka7/hop.nvim',
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require('hop').setup()
    vim.keymap.set('n', 'q', '<cmd>HopChar1<cr>')
    vim.keymap.set('v', 'q', '<cmd>HopChar1<cr>')
    vim.keymap.set('n', 'Q', '<cmd>HopChar2<cr>')
    vim.keymap.set('v', 'Q', '<cmd>HopChar2<cr>')
    -- keys = 'etovxqpdygfblzhckisuran' 
  end
}
