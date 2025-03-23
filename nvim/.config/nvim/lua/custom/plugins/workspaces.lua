return {
	"natecraddock/workspaces.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	keys = {
		{ "<leader>wa", "<cmd>WorkspacesAdd<CR>", desc = "Add workspace" },
		{ "<leader>wr", "<cmd>WorkspacesRemove<CR>", desc = "Remove workspace" },
		{ "<leader>wl", "<cmd>Telescope workspaces<CR>", desc = "List workspaces" },
	},
	config = function()
		require("workspaces").setup({
			hooks = {
				open = { "Telescope find_files" },
			},
		})
		-- Load the workspaces extension for Telescope
		require("telescope").load_extension("workspaces")
	end,
}

-- Workspaces: as described above, are project directories.
-- The purpose of this plugin being to switch easily between these project directories.
--
-- Dirs: These are directories that contain workspaces.
-- It allows to easily sync multiple workspaces contained in a directory.
-- For example, you might have a directory called projects on your machine, that contains all your projects.
-- Just register this directory as a dir with :WorkspacesAddDir and all the workspaces contained in it
-- will be automatically added to the list of workspaces when running :WorkspacesSyncDirs.
--
