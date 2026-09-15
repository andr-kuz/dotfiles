return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = function()
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
    require("nvim-treesitter.config").setup({
      indent = {
        enable = true
      },
    })

    -- 2. Включение нативной продвинутой подсветки Neovim 0.12+
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype) or vim.bo[args.buf].filetype
        -- Проверяем, установлены ли правила подсветки для этого языка, и запускаем движок
        if vim.treesitter.query.get(lang, "highlights") then
          pcall(vim.treesitter.start, args.buf, lang)
        end
      end,
    })
  end
}
