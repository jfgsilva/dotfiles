-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--
if vim.g.neovide then
	vim.o.guifont = "DroidSansM Nerd Font:h17"
	-- set guifont=FiraCode\ Nerd\ Font:h16
	-- set guifont:DroidSansM\ Nerd\ Font:h16
	--
	-- Put anything you want to happen only in Neovide here
end
-- WARNING: the whole return might need to be encased in other curly brackets
return {
	{
		"tris203/precognition.nvim",
		event = "VeryLazy",
		opts = {
			startVisible = false,
			showBlankVirtLine = true,
			highlightColor = { link = "Comment" },
			hints = {
				Caret = { text = "^", prio = 2 },
				Dollar = { text = "$", prio = 1 },
				MatchingPair = { text = "%", prio = 5 },
				Zero = { text = "0", prio = 1 },
				w = { text = "w", prio = 10 },
				b = { text = "b", prio = 9 },
				e = { text = "e", prio = 8 },
				W = { text = "W", prio = 7 },
				B = { text = "B", prio = 6 },
				E = { text = "E", prio = 5 },
			},
			gutterHints = {
				G = { text = "G", prio = 10 },
				gg = { text = "gg", prio = 9 },
				PrevParagraph = { text = "{", prio = 8 },
				NextParagraph = { text = "}", prio = 8 },
			},
		},
	},
	"tpope/vim-fugitive",
	"tpope/vim-unimpaired",
	"tpope/vim-surround",
	"pearofducks/ansible-vim",
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}
