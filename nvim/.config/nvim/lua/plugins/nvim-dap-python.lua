return {
	"mfussenegger/nvim-dap-python",
  -- stylua: ignore
  keys = {
    { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
    { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
  },
	config = function()
		--require("dap-python").setup("uv")
		require("dap-python").setup("~/.venvs/debugpy/bin/python")
	end,
}
