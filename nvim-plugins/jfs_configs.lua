-- making usage of smart cat
-- NOTE: https://github.com/efugier/smartcat

-- Define the custom command function
local function run_sc_command()
	-- Prompt the user to enter "some text"
	local input = vim.fn.input("Enter text for sc command: ")

	-- Run the :'<,'>!sc {input} command in visual mode
	vim.cmd(":'<,'>!sc '" .. input .. "'")
end
-- Set the keybinding in visual mode
vim.keymap.set("v", "<leader>sc", run_sc_command, { desc = "Smart Cat LLM" })

-- adding my own options JFS
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "0"
vim.opt.foldenable = false
vim.opt.tabstop = 4

-- vim.opt.foldnestmax = 4
-- vim.opt.foldtext = ''

-- the following line allows for expansion of %% to base dir from current file
vim.cmd([[
  cnoremap <expr> %% getcmdtype()==':'?expand('%:h').'/':'%%'
]])
return {}
