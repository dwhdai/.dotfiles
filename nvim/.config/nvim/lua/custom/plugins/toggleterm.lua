return {
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    version = '*',
    opts = {},
    keys = {
      { 't', 'Esc', '<c-><c-n>' },
    },
    config = function()
      require('toggleterm').setup {
        -- open_mapping = [[<c-\>]],
        -- close_on_exit = false,
      }
    end,
  },
}
