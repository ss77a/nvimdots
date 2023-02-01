local config = {}
local sessions_dir = vim.fn.stdpath("data") .. "/sessions/"
local use_ssh = require("core.settings").use_ssh

function config.nvim_treesitter()
	vim.api.nvim_set_option_value("foldmethod", "expr", {})
	vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", {})

	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"lua",
			"go",
			"gomod",
			"json",
			"yaml",
			"latex",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"html",
			"javascript",
			"typescript",
			"vue",
			"css",
		},
		highlight = {
			enable = true,
			disable = function(ft, bufnr)
				if vim.tbl_contains({ "vim" }, ft) then
					return true
				end

				local ok, is_large_file = pcall(vim.api.nvim_buf_get_var, bufnr, "bigfile_disable_treesitter")
				return ok and is_large_file
			end,
			additional_vim_regex_highlighting = { "c", "cpp" },
		},
		markid = {
			enable = true,
		},
		illuminate = {
			enable = true,
		},
		textobjects = {
			select = {
				enable = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]["] = "@function.outer",
					["]m"] = "@class.outer",
				},
				goto_next_end = {
					["]]"] = "@function.outer",
					["]M"] = "@class.outer",
				},
				goto_previous_start = {
					["[["] = "@function.outer",
					["[m"] = "@class.outer",
				},
				goto_previous_end = {
					["[]"] = "@function.outer",
					["[M"] = "@class.outer",
				},
			},
		},
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
			max_file_lines = 2000, -- Do not enable for files with more than 2000 lines, int
		},
		context_commentstring = { enable = true, enable_autocmd = false },
		matchup = { enable = true },
	})
	require("nvim-treesitter.install").prefer_git = true
	if use_ssh then
		local parsers = require("nvim-treesitter.parsers").get_parser_configs()
		for _, p in pairs(parsers) do
			p.install_info.url = p.install_info.url:gsub("https://github.com/", "git@github.com:")
		end
	end
end

function config.secretary()
	require("query-secretary").setup({
		open_win_opts = {
			row = 0,
			col = 9999,
			width = 50,
			height = 15,
		},

		-- other options you can customize
		buf_set_opts = {
			tabstop = 2,
			softtabstop = 2,
			shiftwidth = 2,
		},

		capture_group_names = { "cap", "second", "third" }, -- when press "c"
		predicates = { "eq", "any-of", "contains", "match", "lua-match" }, -- when press "p"
		visual_hl_group = "Visual", -- when moving cursor around

		-- here are the default keymaps
		keymaps = {
			close = { "q", "Esc" },
			next_predicate = { "p" },
			previous_predicate = { "P" },
			remove_predicate = { "d" },
			toggle_field_name = { "f" },
			yank_query = { "y" },
			next_capture_group = { "c" },
			previous_capture_group = { "C" },
		},
	})
end

function config.illuminate()
	require("illuminate").configure({
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
		delay = 100,
		filetypes_denylist = {
			"alpha",
			"dashboard",
			"DoomInfo",
			"fugitive",
			"help",
			"norg",
			"NvimTree",
			"Outline",
			"toggleterm",
		},
		under_cursor = false,
	})
end

function config.tsPlayground()
	require("nvim-treesitter.configs").setup({
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
	})
end

function config.nvim_comment()
	require("nvim_comment").setup({
		hook = function()
			require("ts_context_commentstring.internal").update_commentstring()
		end,
	})
end

function config.hop()
	require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
end

function config.autotag()
	require("nvim-ts-autotag").setup({
		filetypes = {
			"html",
			"xml",
			"javascript",
			"typescriptreact",
			"javascriptreact",
			"vue",
		},
	})
end

function config.colorpicker()
	local opts = { noremap = true, silent = true }

	vim.keymap.set("n", "<C-c>", "<cmd>PickColor<cr>", opts)
	vim.keymap.set("i", "<C-c>", "<cmd>PickColorInsert<cr>", opts)

	-- vim.keymap.set("n", "your_keymap", "<cmd>ConvertHEXandRGB<cr>", opts)
	-- vim.keymap.set("n", "your_keymap", "<cmd>ConvertHEXandHSL<cr>", opts)

	require("color-picker").setup({ -- for changing icons & mappings
		-- ["icons"] = { "ﱢ", "" },
		-- ["icons"] = { "ﮊ", "" },
		-- ["icons"] = { "", "ﰕ" },
		-- ["icons"] = { "", "" },
		-- ["icons"] = { "", "" },
		["icons"] = { "ﱢ", "" },
		["border"] = "rounded", -- none | single | double | rounded | solid | shadow
		["keymap"] = { -- mapping example:
			["U"] = "<Plug>ColorPickerSlider5Decrease",
			["O"] = "<Plug>ColorPickerSlider5Increase",
		},
		["background_highlight_group"] = "Normal", -- default
		["border_highlight_group"] = "FloatBorder", -- default
		["text_highlight_group"] = "Normal", --default
	})

	vim.cmd([[hi FloatBorder guibg=NONE]]) -- if you don't want weird border background colors around the popup.
end

function config.nvim_colorizer()
	require("colorizer").setup({
		RGB = true, -- #RGB hex codes
		RRGGBB = true, -- #RRGGBB hex codes
		names = true, -- "Name" codes like Blue
		RRGGBBAA = true, -- #RRGGBBAA hex codes
		rgb_fn = true, -- CSS rgb() and rgba() functions
		hsl_fn = true, -- CSS hsl() and hsla() functions
		css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
		css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
		-- Available modes: foreground, background
		mode = "background", -- Set the display mode.
	})
end

function config.minimap()
	-- for shorthand usage
	local nm = require("neo-minimap")

	-- will reload your neo-minimap config file on save
	-- works only when you have only 1 neo-minimap config file
	nm.source_on_save("/home/sam/.nvim/data/minimap") -- optional

	-- borrowed from creator -- need to add astro, etc

	-- Lua
	nm.set({ "zi", "zo", "zu" }, "*.lua", {
		events = { "BufEnter" },

		query = {
			[[
    ;; query
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]],
			1,
			[[
    ;; query
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((field (identifier) @cap) (#eq? @cap "keymaps"))
    ]],
			[[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
    ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
    ]],
			[[
    ;; query
    ((for_statement) @cap)
    ((function_declaration) @cap)
    ((assignment_statement(expression_list((function_definition) @cap))))
    ]],
		},

		regex = {
			{},
			{ [[^\s*---*\s\+\w\+]], [[--\s*=]] },
			{ [[^\s*---*\s\+\w\+]], [[--\s*=]] },
			{},
		},

		search_patterns = {
			{ "function", "<C-j>", true },
			{ "function", "<C-k>", false },
			{ "keymap", "<A-j>", true },
			{ "keymap", "<A-k>", false },
		},

		-- auto_jump = false,
		-- open_win_opts = { border = "double" },
		win_opts = { scrolloff = 1 },

		-- disable_indentaion = true,
	})

	-- Typescript React javascript typescript
	nm.set("zi", { "typescriptreact", "javascriptreact", "javascript", "typescript" }, {
		query = [[
;; query
((function_declaration) @cap)
((arrow_function) @cap)
((identifier) @cap (#vim-match? @cap "^use.*"))
  ]],
	})

	-- example
	nm.set({ "zi", "zo" }, { "*.astro" }, {
		events = { "BufEnter" },

		-- lua table, values inside can be type `string` or `number`
		-- accepts multiple treesitter queries, corresponse to each keymap,
		-- if you press "keymap1", minimap will start with first query,
		-- if you press "keymap2", minimap will start with second query,
		-- you can have empty query table option if you want to use regex only
		query = {
			[[
        ;; query
        ((function_declaration) @cap)
        ((assignment_statement(expression_list((function_definition) @cap))))
        ]], -- first query
			[[
        ;; query
        ((function_declaration) @cap)
        ((assignment_statement(expression_list((function_definition) @cap))))
        ((for_statement) @cap)
        ]], -- second query

			1, -- if passed in a number, a query with that index will take it's place
			-- in this case, instead of copying the entire first query,
			-- we use `1` to point to it.
		},

		-- optional
		regex = { -- lua table, values inside can be type `table` or `number`
			{ [[--.*]], [[===.*===]] }, -- first set of regexes
			{}, -- no regex
			1, -- acts as first regex set
		},
		-- you can have empty regex option if you want to use Treesitter queries only

		-- optional
		search_patterns = {
			{ "vim_regex", "<C-j>", true }, -- jump to the next instance of "vim_regex"
			{ "vim_regex", "<C-k>", false }, -- jump to the previous instance of "vim_regex"
		},

		auto_jump = true, -- optional, defaults to `true`, auto jump when move cursor

		-- other options
		width = 44, -- optional, defaults to 44, width of the minimap
		height = 12, -- optional, defaults to 12, height of the minimap
		hl_group = "my_hl_group", -- highlight group of virtual text, optional, defaults to "DiagnosticWarn"

		open_win_opts = {}, -- optional, for setting custom `nvim_open_win` options
		win_opts = {}, -- optional, for setting custom `nvim_win_set_option` options

		-- change minimap's height with <C-h>
		-- this means default minimap height is 12
		-- minimap height will change to 36 after pressing <C-h>
		height_toggle = { 12, 36 },

		disable_indentation = false, -- if `true`, will remove any white space / tab at the start of the results.
	})
end

function config.treesitter_surfer()
	-- Syntax Tree Surfer
	local opts = { noremap = true, silent = true }

	-- Normal Mode Swapping:
	-- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
	vim.keymap.set("n", "vU", function()
		vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
		return "g@l"
	end, { silent = true, expr = true })
	vim.keymap.set("n", "vD", function()
		vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
		return "g@l"
	end, { silent = true, expr = true })

	-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
	vim.keymap.set("n", "vd", function()
		vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
		return "g@l"
	end, { silent = true, expr = true })
	vim.keymap.set("n", "vu", function()
		vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
		return "g@l"
	end, { silent = true, expr = true })

	--> If the mappings above don't work, use these instead (no dot repeatable)
	-- vim.keymap.set("n", "vd", '<cmd>STSSwapCurrentNodeNextNormal<cr>', opts)
	-- vim.keymap.set("n", "vu", '<cmd>STSSwapCurrentNodePrevNormal<cr>', opts)
	-- vim.keymap.set("n", "vD", '<cmd>STSSwapDownNormal<cr>', opts)
	-- vim.keymap.set("n", "vU", '<cmd>STSSwapUpNormal<cr>', opts)

	-- Visual Selection from Normal Mode
	vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", opts)
	vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", opts)

	-- Select Nodes in Visual Mode
	vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>", opts)
	vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
	vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", opts)
	vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", opts)

	-- Swapping Nodes in Visual Mode
	vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>", opts)
	vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>", opts)
end

function config.neoscroll()
	require("neoscroll").setup({
		-- All these keys will be mapped to their corresponding default scrolling animation
		mappings = {
			"<C-u>",
			"<C-d>",
			"<C-b>",
			"<C-f>",
			"<C-y>",
			"<C-e>",
			"zt",
			"zz",
			"zb",
		},
		hide_cursor = true, -- Hide cursor while scrolling
		stop_eof = true, -- Stop at <EOF> when scrolling downwards
		use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
		respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
		cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
		easing_function = nil, -- Default easing function
		pre_hook = nil, -- Function to run before the scrolling animation starts
		post_hook = nil, -- Function to run after the scrolling animation ends
	})
end

function config.icon_picker()
	require("icon-picker").setup({
		disable_legacy_commands = true,
	})
end

function config.auto_session()
	local opts = {
		log_level = "info",
		auto_session_enable_last_session = true,
		auto_session_root_dir = sessions_dir,
		auto_session_enabled = true,
		auto_save_enabled = true,
		auto_restore_enabled = true,
		auto_session_suppress_dirs = nil,
	}

	require("auto-session").setup(opts)
end

function config.toggleterm()
	local colors = require("modules.utils").get_palette()
	local floatborder_hl = require("modules.utils").hl_to_rgb("FloatBorder", false, colors.blue)

	require("toggleterm").setup({
		-- size can be a number or function which is passed the current terminal
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.40
			end
		end,
		highlights = {
			FloatBorder = {
				guifg = floatborder_hl,
			},
		},
		on_open = function()
			-- Prevent infinite calls from freezing neovim.
			-- Only set these options specific to this terminal buffer.
			vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
			vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
		end,
		open_mapping = false, -- [[<c-\>]],
		hide_numbers = true, -- hide the number column in toggleterm buffers
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
		start_in_insert = true,
		insert_mappings = true, -- whether or not the open mapping applies in insert mode
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true, -- close the terminal window when the process exits
		shell = vim.o.shell, -- change the default shell
	})
end

function config.dapui()
	local icons = {
		ui = require("modules.ui.icons").get("ui"),
		dap = require("modules.ui.icons").get("dap"),
	}

	require("dapui").setup({
		icons = { expanded = icons.ui.ArrowOpen, collapsed = icons.ui.ArrowClosed, current_frame = icons.ui.Indicator },
		mappings = {
			-- Use a table to apply multiple mappings
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
		},
		layouts = {
			{
				elements = {
					-- Provide as ID strings or tables with "id" and "size" keys
					{
						id = "scopes",
						size = 0.25, -- Can be float or integer > 1
					},
					{ id = "breakpoints", size = 0.25 },
					{ id = "stacks", size = 0.25 },
					{ id = "watches", size = 0.25 },
				},
				size = 40,
				position = "left",
			},
			{ elements = { "repl" }, size = 10, position = "bottom" },
		},
		-- Requires Nvim version >= 0.8
		controls = {
			enabled = true,
			-- Display controls in this session
			element = "repl",
			icons = {
				pause = icons.dap.Pause,
				play = icons.dap.Play,
				step_into = icons.dap.StepInto,
				step_over = icons.dap.StepOver,
				step_out = icons.dap.StepOut,
				step_back = icons.dap.StepBack,
				run_last = icons.dap.RunLast,
				terminate = icons.dap.Terminate,
			},
		},
		floating = {
			max_height = nil,
			max_width = nil,
			mappings = { close = { "q", "<Esc>" } },
		},
		windows = { indent = 1 },
	})
end

function config.dap()
	local icons = { dap = require("modules.ui.icons").get("dap") }
	local colors = require("modules.utils").get_palette()

	local dap = require("dap")
	local dapui = require("dapui")

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.after.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.after.event_exited["dapui_config"] = function()
		dapui.close()
	end

	-- We need to override nvim-dap's default highlight groups, AFTER requiring nvim-dap for catppuccin.
	vim.api.nvim_set_hl(0, "DapStopped", { fg = colors.green })

	vim.fn.sign_define(
		"DapBreakpoint",
		{ text = icons.dap.Breakpoint, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = icons.dap.BreakpointCondition, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapStopped", { text = icons.dap.Stopped, texthl = "DapStopped", linehl = "", numhl = "" })
	vim.fn.sign_define(
		"DapBreakpointRejected",
		{ text = icons.dap.BreakpointRejected, texthl = "DapBreakpoint", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapLogPoint", { text = icons.dap.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })

	dap.adapters.lldb = {
		type = "executable",
		command = "/usr/bin/lldb-vscode",
		name = "lldb",
	}
	dap.configurations.cpp = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},

			-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
			--
			--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
			--
			-- Otherwise you might get the following error:
			--
			--    Error on launch: Failed to attach to the target process
			--
			-- But you should be aware of the implications:
			-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
			runInTerminal = false,
		},
	}

	dap.configurations.c = dap.configurations.cpp
	dap.configurations.rust = dap.configurations.cpp

	dap.adapters.go = function(callback)
		local stdout = vim.loop.new_pipe(false)
		local handle
		local pid_or_err
		local port = 38697
		local opts = {
			stdio = { nil, stdout },
			args = { "dap", "-l", "127.0.0.1:" .. port },
			detached = true,
		}
		handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
			stdout:close()
			handle:close()
			if code ~= 0 then
				vim.notify(
					string.format('"dlv" exited with code: %d, please check your configs for correctness.', code),
					vim.log.levels.WARN,
					{ title = "[go] DAP Warning!" }
				)
			end
		end)
		assert(handle, "Error running dlv: " .. tostring(pid_or_err))
		stdout:read_start(function(err, chunk)
			assert(not err, err)
			if chunk then
				vim.schedule(function()
					require("dap.repl").append(chunk)
				end)
			end
		end)
		-- Wait for delve to start
		vim.defer_fn(function()
			callback({ type = "server", host = "127.0.0.1", port = port })
		end, 100)
	end
	-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
	dap.configurations.go = {
		{ type = "go", name = "Debug", request = "launch", program = "${file}" },
		{
			type = "go",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
			mode = "test",
			program = "${file}",
		}, -- works with go.mod packages and sub packages
		{
			type = "go",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	}

	dap.adapters.python = {
		type = "executable",
		command = "/usr/bin/python",
		args = { "-m", "debugpy.adapter" },
	}
	dap.configurations.python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",
			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
	}
end

function config.specs()
	require("specs").setup({
		show_jumps = true,
		min_jump = 10,
		popup = {
			delay_ms = 0, -- delay before popup displays
			inc_ms = 10, -- time increments used for fade/resize effects
			blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
			width = 10,
			winhl = "PMenu",
			fader = require("specs").pulse_fader,
			resizer = require("specs").shrink_resizer,
		},
		ignore_filetypes = {},
		ignore_buftypes = { nofile = true },
	})
end

function config.imselect()
	-- fcitx5 need a manual config
	if vim.fn.executable("fcitx5-remote") == 1 then
		vim.api.nvim_cmd({
			[[ let g:im_select_get_im_cmd = ["fcitx5-remote"] ]],
			[[ let g:im_select_default = '1' ]],
			[[ let g:ImSelectSetImCmd = {
			\ key ->
			\ key == 1 ? ['fcitx5-remote', '-c'] :
			\ key == 2 ? ['fcitx5-remote', '-o'] :
			\ key == 0 ? ['fcitx5-remote', '-c'] :
			\ execute("throw 'invalid im key'")
			\ }
			]],
		}, { true, true, true })
	end
end

function config.better_escape()
	require("better_escape").setup({
		mapping = { "jk", "jj" }, -- a table with mappings to use
		timeout = 500, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
		clear_empty_lines = false, -- clear line after escaping if there is only whitespace
		keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
		-- example(recommended)
		-- keys = function()
		--   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
		-- end,
	})
end

function config.accelerated_jk()
	require("accelerated-jk").setup({
		mode = "time_driven",
		enable_deceleration = false,
		acceleration_motions = {},
		acceleration_limit = 150,
		acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
		-- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
		deceleration_table = { { 150, 9999 } },
	})
end

function config.markid()
	local M = require("markid")
	require("nvim-treesitter.configs").setup({
		markid = {
			enable = true,
			colors = M.colors.medium,
			queries = M.queries,
			is_supported = function(lang)
				local queries = config.get_module("markid").queries
				return pcall(vim.treesitter.parse_query, lang, queries[lang] or queries["default"])
			end,
		},
	})

	M.colors = {
		dark = {
			"#619e9d",
			"#9E6162",
			"#81A35C",
			"#7E5CA3",
			"#9E9261",
			"#616D9E",
			"#97687B",
			"#689784",
			"#999C63",
			"#66639C",
		},
		bright = {
			"#f5c0c0",
			"#f5d3c0",
			"#f5eac0",
			"#dff5c0",
			"#c0f5c8",
			"#c0f5f1",
			"#c0dbf5",
			"#ccc0f5",
			"#f2c0f5",
			"#98fc03",
		},
		medium = {
			"#c99d9d",
			"#c9a99d",
			"#c9b79d",
			"#c9c39d",
			"#bdc99d",
			"#a9c99d",
			"#9dc9b6",
			"#9dc2c9",
			"#9da9c9",
			"#b29dc9",
		},
	}

	M.queries = {
		default = "(identifier) @markid",
		javascript = [[
              (identifier) @markid
              (property_identifier) @markid
              (shorthand_property_identifier_pattern) @markid
            ]],
	}
	M.queries.typescript = M.queries.javascript
end

function config.astro()
	vim.cmd([[let g:astro_typescript = 'enable']])
end

function config.substitute()
	require("substitute").setup({
		on_substitute = nil,
		yank_substituted_text = false,
		range = {
			prefix = "s",
			prompt_current_text = false,
			confirm = false,
			complete_word = false,
			motion1 = false,
			motion2 = false,
			suffix = "",
		},
		exchange = {
			motion = false,
			use_esc_to_cancel = true,
		},
	})

	vim.keymap.set("n", "ts", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
	vim.keymap.set("n", "tt", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
	vim.keymap.set("n", "T", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
	vim.keymap.set("x", "ts", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })

	vim.keymap.set("n", "tx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
	vim.keymap.set("n", "txx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
	vim.keymap.set("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
	vim.keymap.set("n", "txc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
end

function config.clever_f()
	vim.api.nvim_set_hl(
		0,
		"CleverChar",
		{ underline = true, bold = true, fg = "Orange", bg = "NONE", ctermfg = "Red", ctermbg = "NONE" }
	)
	vim.g.clever_f_mark_char_color = "CleverChar"
	vim.g.clever_f_mark_direct_color = "CleverChar"
	vim.g.clever_f_mark_direct = true
	vim.g.clever_f_timeout_ms = 1500
end

function config.smartyank()
	require("smartyank").setup({
		highlight = {
			enabled = false, -- highlight yanked text
			higroup = "IncSearch", -- highlight group of yanked text
			timeout = 2000, -- timeout for clearing the highlight
		},
		clipboard = {
			enabled = true,
		},
		tmux = {
			enabled = true,
			-- remove `-w` to disable copy to host client's clipboard
			cmd = { "tmux", "set-buffer", "-w" },
		},
		osc52 = {
			enabled = true,
			escseq = "tmux", -- use tmux escape sequence, only enable if you're using remote tmux and have issues (see #4)
			ssh_only = true, -- false to OSC52 yank also in local sessions
			silent = false, -- true to disable the "n chars copied" echo
			echo_hl = "Directory", -- highlight group of the OSC52 echo message
		},
	})
end

function config.navic()
	local navic = require("navic")

	local lspconfig = require("plugins.configs.lspconfig")

	local on_attach = function(client, bufnr)
		if client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
		end
	end

	lspconfig.clangd.setup({
		on_attach = on_attach,
	})
end

function config.tabout()
	require("tabout").setup({
		tabkey = "", -- key to trigger tabout, set to an empty string to disable
		backwards_tabkey = "", -- key to trigger backwards tabout, set to an empty string to disable
		act_as_tab = true, -- shift content if tab out is not possible
		act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
		enable_backwards = true,
		completion = true, -- if the tabkey is used in a completion pum
		tabouts = {
			{ open = "'", close = "'" },
			{ open = '"', close = '"' },
			{ open = "`", close = "`" },
			{ open = "(", close = ")" },
			{ open = "[", close = "]" },
			{ open = "{", close = "}" },
		},
		ignore_beginning = true, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
		exclude = {}, -- tabout will ignore these filetypes
	})
end

function config.bigfile()
	local ftdetect = {
		name = "ftdetect",
		opts = { defer = true },
		disable = function()
			vim.api.nvim_set_option_value("filetype", "big_file_disabled_ft", { scope = "local" })
		end,
	}

	local cmp = {
		name = "nvim-cmp",
		opts = { defer = true },
		disable = function()
			require("cmp").setup.buffer({ enabled = false })
		end,
	}

	require("bigfile").config({
		filesize = 1, -- size of the file in MiB
		pattern = { "*" }, -- autocmd pattern
		features = { -- features to disable
			"indent_blankline",
			"lsp",
			"illuminate",
			"treesitter",
			"syntax",
			"vimopts",
			ftdetect,
			cmp,
		},
	})
end

return config
