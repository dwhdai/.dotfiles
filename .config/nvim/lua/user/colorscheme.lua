local colorscheme = "sonokai"
--vim.cmd "let g:sonokai_style = 'andromeda'"
--vim.cmd "let g:sonokai_better_performance = 1"
--vim.cmd "colorscheme sonokai"

if colorscheme == "sonokai" then
  vim.cmd "let g:sonokai_style = 'andromeda'"
  vim.cmd "let g:sonokai_better_performance = 1"
end

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
