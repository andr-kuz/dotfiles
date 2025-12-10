return {
  'catppuccin/nvim',
  name = 'catppuccin',
  config = function()
    require('catppuccin').setup({
      flavour = 'frappe', -- or 'latte', 'macchiato', 'mocha'
      custom_highlights = function(colors)
        return {
          -- Override Hop highlights
          HopNextKey  = { link = 'Constant' },
          HopNextKey1 = { link = 'Label' },
          HopNextKey2 = { link = 'Label' },
          HopCursor = { link = 'Cursor' }, -- Keeps the link
          HopPreview = { link = 'IncSearch' }, -- Keeps the link
        }
      end,
    })
    vim.cmd.colorscheme('catppuccin-frappe')
  end
}
