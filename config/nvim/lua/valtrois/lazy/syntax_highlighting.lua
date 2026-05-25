return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = function()
    -- Правильный метод установки базовых парсеров в ветке main
    require("nvim-treesitter").install({
      "python",
      "lua",
      "sql",
      "bash",
      "markdown",
      "markdown_inline",
    })
  end,
  config = function()
    -- Настройка стандартной подсветки синтаксиса Neovim (Treesitter)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype) or vim.bo[args.buf].filetype

        -- Запускаем подсветку, только если парсер присутствует в системе
        if vim.treesitter.query.get(lang, "highlights") then
          if pcall(vim.treesitter.start, args.buf, lang) then
            vim.bo[args.buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"
          end
        end
      end,
    })
  end
}
