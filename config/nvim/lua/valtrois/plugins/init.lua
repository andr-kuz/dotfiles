local current_dir = vim.fn.expand("%:p:h")

for _, file in ipairs(vim.fn.readdir(current_dir .. "/plugins", [[v:val =~ '\.lua$']])) do
  if file ~= "init.lua" then
    -- Clean the extension
    local module_name = file:gsub("%.lua$", "")

    -- Append the correct directory prefix: "valtrois.plugins.scroll_eof"
    require("valtrois.plugins." .. module_name)
  end
end
