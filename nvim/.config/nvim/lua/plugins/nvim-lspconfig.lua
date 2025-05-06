return {
	"neovim/nvim-lspconfig",
	opts = {
		inlay_hints = { enabled = false },
		diagnostics = { virtual_text = false },
	},
	servers = { basedpyright = { typeCheckingMode = "standard" } },
	setup = {
		basedpyright = function()
			require("lspconfig").basedpyright.setup({
				settings = {
					typeCheckingMode = "standard",
				},
			})
		end,
	},
}
