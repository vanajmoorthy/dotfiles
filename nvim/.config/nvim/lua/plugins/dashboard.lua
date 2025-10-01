-- ~/.config/nvim/lua/plugins/dashboard.lua
return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- ASCII Art Header
			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
				"                                                     ",
			}
			dashboard.section.header.opts.hl = "Yellow"

			-- Info section with custom highlights
			local function get_info()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
				local plugin_text = stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"

				-- Ensure consistent width (52 characters inside the box)
				local cwd_padding = string.rep(" ", 52 - #cwd)
				local plugin_padding = string.rep(" ", 52 - #plugin_text)

				return {
					{
						type = "text",
						val = "╭──────────────────────────────────────────────────────╮",
						opts = { hl = "Blue", position = "center" },
					},
					{
						type = "text",
						val = "│                                                      │",
						opts = { hl = "Blue", position = "center" },
					},
					{
						type = "text",
						val = "│  " .. cwd .. cwd_padding .. "│",
						opts = { hl = "Aqua", position = "center" },
					},
					{
						type = "text",
						val = "│  " .. plugin_text .. plugin_padding .. "│",
						opts = { hl = "Blue", position = "center" },
					},
					{
						type = "text",
						val = "│                                                      │",
						opts = { hl = "Blue", position = "center" },
					},
					{
						type = "text",
						val = "╰──────────────────────────────────────────────────────╯",
						opts = { hl = "Blue", position = "center" },
					},
				}
			end

			-- Recent files
			local function get_recent_files()
				local recent = {
					{
						type = "text",
						val = "╭──────────────────────────────────────────────────────╮",
						opts = { hl = "Blue", position = "center" },
					},
					{
						type = "text",
						val = "│                   Recent Files                       │",
						opts = { hl = "Blue", position = "center" },
					},
					{
						type = "text",
						val = "├──────────────────────────────────────────────────────┤",
						opts = { hl = "Blue", position = "center" },
					},
				}

				local oldfiles = vim.v.oldfiles
				local cwd = vim.fn.getcwd()
				local count = 0

				for _, file in ipairs(oldfiles) do
					if count >= 5 then
						break
					end
					if vim.startswith(file, cwd) and vim.fn.filereadable(file) == 1 then
						local short = vim.fn.fnamemodify(file, ":.")
						if #short > 50 then
							short = "..." .. short:sub(-47)
						end
						local padding = string.rep(" ", 52 - #short)
						table.insert(recent, {
							type = "button",
							val = "│  " .. short .. padding .. "│",
							on_press = function()
								vim.cmd("edit " .. file)
							end,
							opts = { hl = "Blue", shortcut = "", position = "center" },
						})
						count = count + 1
					end
				end

				if count == 0 then
					local no_files = "No recent files"
					local padding = string.rep(" ", 52 - #no_files)
					table.insert(recent, {
						type = "text",
						val = "│  " .. no_files .. padding .. "│",
						opts = { hl = "Blue", position = "center" },
					})
				end

				table.insert(recent, {
					type = "text",
					val = "╰──────────────────────────────────────────────────────╯",
					opts = { hl = "Blue", position = "center" },
				})

				return recent
			end

			-- Build the layout
			local function build_layout()
				local info_lines = get_info()
				local info_section = {
					type = "group",
					val = info_lines,
					opts = {
						position = "center",
					},
				}

				local recent_files = get_recent_files()

				return {
					{ type = "padding", val = 12 },
					dashboard.section.header,
					{ type = "padding", val = 2 },
					info_section,
					{ type = "padding", val = 1 },
					{ type = "group", val = recent_files, opts = { spacing = 0 } },
					{ type = "padding", val = 2 },
					dashboard.section.footer,
				}
			end

			-- Footer
			dashboard.section.footer.val = {
				"ff: find files  │  fw: grep  │  q: quit",
			}
			dashboard.section.footer.opts.hl = "Orange"

			alpha.setup({
				layout = build_layout(),
				opts = {
					margin = 5,
				},
			})

			vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
		end,
	},
}
