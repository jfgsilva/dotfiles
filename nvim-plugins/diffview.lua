-- lua/plugins/diffview.lua
return {
	"sindrets/diffview.nvim",
	cmd = "DiffviewOpen",
	cond = function()
		-- Check if current directory is a git repository
		vim.fn.system("git rev-parse --is-inside-work-tree")
		return vim.v.shell_error == 0
	end,
	config = function()
		require("diffview").setup({
			-- Your diffview configuration here (if needed)
		})
	end,
	init = function()
		-- Define toggle_diffview and specific command functions
		local function toggle_diffview(cmd)
			local diffview_lib = require("diffview.lib")
			if next(diffview_lib.views) == nil then
				vim.cmd(cmd)
			else
				vim.cmd("DiffviewClose")
			end
		end

		-- Function to get default branch name (master or main)
		local function get_default_branch()
			-- Try to get the default branch name
			local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null")
			if handle then
				local result = handle:read("*a")
				handle:close()

				-- Extract branch name from the result
				local branch_name = result:match("refs/remotes/origin/(.+)")
				if branch_name then
					branch_name = branch_name:gsub("%s+", "")
					if branch_name ~= "" then
						return branch_name
					end
				end
			end

			-- Check if master exists
			handle = io.popen("git rev-parse --verify master 2>/dev/null")
			if handle then
				local result = handle:read("*a")
				handle:close()
				if result and result ~= "" then
					return "master"
				end
			end

			-- Check if main exists
			handle = io.popen("git rev-parse --verify main 2>/dev/null")
			if handle then
				local result = handle:read("*a")
				handle:close()
				if result and result ~= "" then
					return "main"
				end
			end

			-- Default to master if nothing else works
			return "main"
		end

		-- Define specific command functions
		local function diff_index()
			toggle_diffview("DiffviewOpen")
		end

		local function diff_master()
			local default_branch = get_default_branch()
			toggle_diffview("DiffviewOpen " .. default_branch .. "..HEAD")
		end

		local function diff_file_history()
			toggle_diffview("DiffviewFileHistory %")
		end

		-- Store functions in a table that can be accessed by the keys
		_G.diffview_commands = {
			diff_index = diff_index,
			diff_master = diff_master,
			diff_file_history = diff_file_history,
		}
	end,
	keys = {
		{
			"<leader>gd",
			function()
				_G.diffview_commands.diff_index()
			end,
			mode = { "n" },
			desc = "Diff Index",
		},
		{
			"<leader>gD",
			function()
				_G.diffview_commands.diff_master()
			end,
			mode = { "n" },
			desc = "Diff Default Branch",
		},
		{
			"<leader>gf",
			function()
				_G.diffview_commands.diff_file_history()
			end,
			mode = { "n" },
			desc = "Open diffs for current File",
		},
	},
}
