return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "frankroeder/parrot.nvim" },
	config = function()
		local function parrot_status()
			local status_info = require("parrot.config").get_status_info()
			local status = ""
			if status_info.is_chat then
				status = status_info.prov.chat.name
			else
				status = status_info.prov.command.name
			end
			return string.format("%s(%s)", status, status_info.model)
		end

		require("lualine").setup({
			sections = {
				lualine_a = { parrot_status },
			},
		})
	end,
}
