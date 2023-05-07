local ui = {}

ui["goolord/alpha-nvim"] = {
    lazy = true,
    event = "BufWinEnter",
    config = require("ui.alpha")
}
ui["akinsho/bufferline.nvim"] = {
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    config = require("ui.bufferline")
}
ui["catppuccin/nvim"] = {
    lazy = false,
    name = "catppuccin",
    config = require("ui.catppuccin")
}
ui["sainnhe/edge"] = {lazy = true, config = require("ui.edge")}
ui["j-hui/fidget.nvim"] = {
	lazy = true,
	event = "LspAttach",
	config = require("ui.fidget"),
}
ui["lewis6991/gitsigns.nvim"] = {
    lazy = true,
    event = {"CursorHold", "CursorHoldI"},
    config = require("ui.gitsigns")
}
ui["lukas-reineke/indent-blankline.nvim"] = {
    lazy = true,
    event = "BufReadPost",
    config = require("ui.indent-blankline")
}
ui["nvim-lualine/lualine.nvim"] = {
    lazy = true,
    event = {"BufReadPost", "BufAdd", "BufNewFile"},
    config = require("ui.lualine")
}
ui["zbirenbaum/neodim"] = {
    lazy = true,
    event = "LspAttach",
    config = require("ui.neodim")
}
ui["karb94/neoscroll.nvim"] = {
    lazy = true,
    event = "BufReadPost",
    config = require("ui.neoscroll")
}
ui["shaunsingh/nord.nvim"] = {lazy = true, config = require("ui.nord")}
ui["rcarriga/nvim-notify"] = {
    lazy = true,
    event = "VeryLazy",
    config = require("ui.notify")
}
ui["folke/paint.nvim"] = {
    lazy = true,
    event = {"CursorHold", "CursorHoldI"},
    config = require("ui.paint")
}
ui["dstein64/nvim-scrollview"] = {
    lazy = true,
    event = "BufReadPost",
    config = require("ui.scrollview")
}
ui["edluffy/specs.nvim"] = {
    lazy = true,
    event = "CursorMoved",
    config = require("ui.specs")
}

ui["folke/tokyonight.nvim"] = {lazy = true, config = require("ui.tokyo-night")}
ui["roobert/tailwindcss-colorizer-cmp.nvim"] = {
    lazy = false,
    config = require("ui.tw-colorizer")
}
ui["shortcuts/no-neck-pain.nvim"] = {
    lazy = false,
    version = "*",
    cmd = "NoNeckPain",
    config = require("ui.no-neck-pain")
}
ui["sindrets/diffview.nvim"] = {lazy = true, config = require("ui.diffview")}

ui["themaxmarchuk/tailwindcss-colors.nvim"] = {
    -- load only on require("tailwindcss-colors")
    module = "tailwindcss-colors",
    -- run the setup function after plugin is loaded
    config = function()
        -- pass config options here (or nothing to use defaults)
        require("tailwindcss-colors").setup()
    end
}

ui["gbprod/phpactor.nvim"] = {
    -- run = require("phpactor.handler.update"), -- To install/update phpactor when installing this plugin
    dependencies = {
        "nvim-lua/plenary.nvim", -- required to update phpactor
        "neovim/nvim-lspconfig" -- required to automatically register lsp serveur
    },
    config = function()
        require("phpactor").setup({
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            install = {
                path = "/home/sam/.cfg/phpactor/",
                branch = "master",
                bin = "/home/sam/.cfg/bin/phpactor",
                php_bin = "php",
                composer_bin = "composer",
                git_bin = "git",
                check_on_startup = "none"
            },
            lspconfig = {enabled = true, options = {}}
        })
    end
}
ui["jackMort/ChatGPT.nvim"] = {
    dependencies = {
        "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },
    config = require("ui.chat-gpt")
}
return ui
