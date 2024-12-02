return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  keys = { { '<leader>e', '<cmd>Neotree toggle<CR>', desc = 'Toggle Neotree' } },

  config = function()
    require('neo-tree').setup {}
  end,
}
