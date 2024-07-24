return {
	"nvim-neotest/nvim-nio",
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"leoluz/nvim-dap-go",
		"Weissle/persistent-breakpoints.nvim",
	},
	config = function()
		local dap = require("dap")

		-- Setup the go debug adapter
		require("dap-go").setup()

		-- Setup DAP virtual text
		require("nvim-dap-virtual-text").setup({})
		vim.g.dap_virtual_text = true

		-- Allows breakpoints to last between sessions
		require("persistent-breakpoints").setup({
			load_breakpoints_event = { "BufReadPost" },
		})

		-- Setup DAP UI
		local dapui = require("dapui")
		dapui.setup()

		-- Automatically open the DAP UI when the debugging session begins
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Adding symbols for breakpoints and such
		vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "→", texthl = "", linehl = "", numhl = "" })

		-- Keymaps for debugging
		vim.keymap.set("n", "<leader>db", require("persistent-breakpoints.api").toggle_breakpoint)
		vim.keymap.set("n", "<leader>dc", dap.continue)
		vim.keymap.set("n", "<leader>dt", dapui.toggle)
		vim.keymap.set("n", "<F5>", function()
			require("dap").continue()
		end)
		vim.keymap.set("n", "<F10>", function()
			require("dap").step_over()
		end)
		vim.keymap.set("n", "<F11>", function()
			require("dap").step_into()
		end)
		vim.keymap.set("n", "<F12>", function()
			require("dap").step_out()
		end)
		vim.keymap.set("n", "<Leader>b", function()
			require("dap").toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>B", function()
			require("dap").set_breakpoint()
		end)
	end,
}
