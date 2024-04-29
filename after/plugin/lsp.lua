local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "jedi_language_server", "bashls" },

	handlers = {
		--- this first function is the "default handler"
		--- it applies to every language server without a "custom handler"
		function(server_name)
			require("lspconfig")[server_name].setup({ single_file_mode = true })
		end,

		--- this is the "custom handler" for `example_server`
		--- in your own config you should replace `example_server`
		--- with the name of a language server you have installed
		-- example_server = function()
		--- in this function you can setup
		--- the language server however you want.
		--- in this example we just use lspconfig

		-- require('lspconfig').example_server.setup({
		---
		-- in here you can add your own
		-- custom configuration
		---
		--  })
		--end,
	},
})

-- Autocompletion setup
local cmp = require("cmp")

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
	},
	mapping = {
		["<C-y>"] = cmp.mapping.confirm({ select = false }),
		["<C-e>"] = cmp.mapping.abort(),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
		["<C-p>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item({ behavior = "insert" })
			else
				cmp.complete()
			end
		end),
		["<Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({ behavior = "insert" })
			else
				cmp.complete()
			end
		end),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})
