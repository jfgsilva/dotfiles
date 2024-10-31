-- adding my own options JFS
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevelstart = 1
vim.opt.foldcolumn = '0'
vim.opt.foldenable = false
vim.opt.tabstop = 4

-- vim.opt.foldnestmax = 4
-- vim.opt.foldtext = ''

-- the following line allows for expansion of %% to base dir from current file
vim.cmd [[
  cnoremap <expr> %% getcmdtype()==':'?expand('%:h').'/':'%%'
]]
return {}
