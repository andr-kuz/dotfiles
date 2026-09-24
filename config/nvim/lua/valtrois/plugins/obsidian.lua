return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  event = {
    'BufReadPre ' .. vim.fn.expand('~') .. '/zettelkasten/**.md',
    'BufNewFile ' .. vim.fn.expand('~') .. '/zettelkasten/**.md',
  },
  dependencies = {
    -- Required
    'nvim-lua/plenary.nvim',
  },
  opts = {
    daily_notes = {
      date_format = "%d-%m-%Y",
    },
    workspaces = {
      {
        name = 'personal',
        path = '~/zettelkasten/',
      },
    },
    finder = 'telescope.nvim',
    note_id_func = function(title)
      return tostring(title)
    end,
      -- Optional, alternatively you can customize the frontmatter data.
    frontmatter = {
      func = function(note)
        -- This is equivalent to the default frontmatter function.
        local created = require("utils.time").get_zettel_timestamp()
        local out = { aliases = note.aliases, tags = note.tags, created = created}
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
    },
  },
}
