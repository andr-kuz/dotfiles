local snippet = vim.snippet

function snippet.add(trigger, body, file_type, opts)
  ---@param trigger string trigger string for snippet
  ---@param body string snippet text that will be expanded
  ---@param file_type? string optional filetype where snippet should be active
  ---@param opts? vim.keymap.set.Opts
  ---
  ---Refer to `:h vim.snippet.expand`
  ---for the specification of valid body.

  vim.keymap.set('ia', trigger, function()
    -- If abbrev is expanded with keys like "(", ")", "<cr>", "<space>",
    -- don't expand the snippet. Only accept "<c-]>" as trigger key.
    local c = vim.fn.nr2char(vim.fn.getchar(0))
    if c ~= '' then
      vim.api.nvim_feedkeys(trigger .. c, 'i', true)
      return
    end

    if file_type and type(file_type) == 'string' and vim.bo.filetype ~= file_type then
      return
    end
    vim.snippet.expand(body)
  end, opts)
end

snippet.add('def', [[
def ${1:function_name}(${2:self}) -> ${3:None}:
    ${4:...}
]], 'python')
