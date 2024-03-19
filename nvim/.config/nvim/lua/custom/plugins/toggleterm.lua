return {
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    version = '*',
    opts = {},
    keys = {
      -- { 't', 'Esc', '<c-\\><c-n>' },
      --{ 't', 'jj', '<c-\\><c-n>' },
      { "<A-'>", '<cmd>ToggleTermToggleAll<cr>', desc = 'ToggleTerm' },
    },
    config = function()
      require('toggleterm').setup {
        always_show_bufferline = true,
        close_on_exit = false,
        direction = 'float',
      }
    end,
  },
}
