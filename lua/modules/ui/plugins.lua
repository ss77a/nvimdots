local ui = {}
local conf = require("modules.ui.config")

ui["shaunsingh/nord.nvim"] = { opt = false, config = conf.nord }
ui["sainnhe/edge"] = { opt = false, config = conf.edge }
ui["folke/paint.nvim"] = {
	opt = false,
	as = "paint",
	config = conf.paint,
}
ui["folke/tokyonight.nvim"] = {
	opt = false,
	as = "toykonight",
	config = conf.toykonight,
}
ui["shaunsingh/nord.nvim"] = {
	lazy = true,
	config = conf.nord,
}
ui["sainnhe/edge"] = {
	lazy = true,
	config = conf.edge,
}
ui["catppuccin/nvim"] = {
	lazy = false,
	name = "catppuccin",
	config = conf.catppuccin,
}
ui["rcarriga/nvim-notify"] = {
	lazy = true,
	event = "VeryLazy",
	config = conf.notify,
}
ui["zbirenbaum/neodim"] = {
	lazy = true,
	event = "LspAttach",
	config = conf.neodim,
}
ui["nvim-lualine/lualine.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = conf.lualine,
}
ui["goolord/alpha-nvim"] = {
	lazy = true,
	event = "BufWinEnter",
	config = conf.alpha,
}
ui["nvim-tree/nvim-tree.lua"] = {
	lazy = true,
	cmd = {
		"NvimTreeToggle",
		"NvimTreeOpen",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeRefresh",
	},
	config = conf.nvim_tree,
}
ui["lewis6991/gitsigns.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	config = conf.gitsigns,
}
ui["lukas-reineke/indent-blankline.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = conf.indent_blankline,
}
ui["akinsho/bufferline.nvim"] = {
	lazy = true,
	event = { "BufReadPost", "BufAdd", "BufNewFile" },
	config = conf.nvim_bufferline,
}
ui["dstein64/nvim-scrollview"] = {
	lazy = true,
	event = "BufReadPost",
	config = conf.scrollview,
}
ui["j-hui/fidget.nvim"] = {
	lazy = true,
	event = "BufReadPost",
	config = conf.fidget,
}

ui["ThemerCorp/themer.lua"] = {
	opt = false,
	config = conf.themer,
}

ui["nvim-neo-tree/neo-tree.nvim"] = {
	branch = "v2.x",
	opt = true,
	module = "neotree",
	cmd = "Neotree",
	config = conf.neotree,
	requires = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		{
			-- only needed if you want to use the commands with "_with_window_picker" suffix
			"s1n7ax/nvim-window-picker",
			tag = "v1.*",
			config = function()
				require("window-picker").setup({
					autoselect_one = true,
					include_current = false,
					filter_rules = {
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { "neo-tree", "neo-tree-popup", "notify" },

							-- if the buffer type is one of following, the window will be ignored
							buftype = { "terminal", "quickfix" },
						},
					},
					other_win_hl_color = "#e35e4f",
				})
			end,
		},
	},
}

return ui
