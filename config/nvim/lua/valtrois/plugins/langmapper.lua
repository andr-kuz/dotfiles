return {
  'Wansmer/langmapper.nvim',
  enabled = true,
  lazy = false,  -- priority option is for non-lazy plugins only
  priority = 999, -- High priority is needed if you will use `autoremap()`
  config = function()
    local langmapper = require('langmapper')
    langmapper.setup({
      layouts = {
        ru = {
          ---@type string Name of your second keyboard layout in system.
          ---It should be the same as result string of `get_current_layout_id()`
          id = '1',
        },
      },
      os = {
        -- Linux, the result of `vim.loop.os_uname().sysname`
        Linux = {
          ---@return string
          get_current_layout_id = function()
            local output = vim.fn.system('niri msg keyboard-layouts')
            return output:match('%*%s+(%d+)')
          end,
        },
      },
    })
  end,
}
